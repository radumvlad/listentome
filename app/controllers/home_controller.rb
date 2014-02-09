class HomeController < ApplicationController
	def index
		
	  if user_signed_in?
	  	@song = Song.new
	  end


	  if Song.all != nil
	  	@songs = bestFive
    	@songs.sort! { |b,a| a.UserSong.boost <=> b.UserSong.boost }
	  else
	  	@songs = []
	  end
	  
	  #startTime va fi timpul luat din baza ( sysdate - de cand a inceput melodia )
	  #youtubeId va fi id-ul melodiei curente

	  @startTime = 20 
	  @youtubeId = 'JW5meKfy3fY'

	end


 	def bestFive
    	return Song.where(playlist: TRUE).order(:created_at).includes(:UserSong).order('"user_songs"."boost"').limit(5)
  	end


	def addPointsToUser
	  user_song = UserSong.where(song_id: params[:song_id]).first

	  user = User.find(user_song.user_id)
	  user.points += user_song.boost
	  user.save

	  user_song.boost = 0
	  user_song.save
	end

	def boostSong
	  song = Song.order(boost: :desc).limit(1)
	  song.playing = true
	  song.playlist = false
	  song.save

	end

end
