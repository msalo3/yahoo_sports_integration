module Yahoo
  class League

    def initialize(hash)
      puts hash
      @id = hash['league_id']
      @name = hash['name']
      @number_of_teams = hash['num_teams']
      @is_cash_league = hash['is_cash_league']
      @current_week = hash['current_week']
      @season = hash['season']

    end

    def as_hash
      {
        id: @id.to_s,
        name: @name,
        number_of_teams: @number_of_teams,
        cash_league: @is_cash_league,
        current_week: @current_week,
        season: @season
      }
    end

  end
end
