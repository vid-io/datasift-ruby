require './auth'
class PushApi < DataSiftExample
  def initialize
    super
  end

  def run
    begin
      @params = {:output_type => 'pull'}
      puts 'Validating'
      if @datasift.push.valid? @params
        stream = @datasift.compile 'interaction.content contains "music"'
        subscription = create_push(stream[:data][:hash])

        subscription_id = subscription[:data][:id]
        # Pull interactions from the push queue - this will only work if we have set
        # the Push Subscription output_type above to 'pull'

        puts 'Waiting...'
        sleep 10

        # Passing a lambda is more efficient because it is executed once for each interaction received
        # this saves having to iterate over the array returned so the same iteration isn't done twice
        puts 'Pulling'
        @datasift.push.pull(subscription_id, 20971520, '', lambda{ |e| puts "on_message => #{e}" })

        puts 'Waiting...'
        sleep 10
        puts 'Pulling'
        @datasift.push.pull(subscription_id, 20971520, '', lambda{ |e| puts "on_message => #{e}" })

        puts 'Stop Subscription'
        @datasift.push.stop subscription_id

        puts 'Delete Subscription'
        @datasift.push.delete subscription_id
      end
    rescue DataSiftError => dse
      puts dse
    end
  end

end
PushApi.new().run