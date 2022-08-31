class Song

  attr_accessor :name, :album, :id

  def initialize(name:, album:, id: nil)
    @id = id
    @name = name
    @album = album
  end

  # NOTE: This is a Class method with 'self.' because it is the Song Class's job to create the table that
  # it will be mapped to later on
  def self.create_table
    # NOTE: The '<<-' section is known as a 'Heredoc' syntax
    # https://en.wikipedia.org/wiki/Here_document
    sql = <<-SQL
CREATE TABLE IF NOT EXISTS songs (
id INTEGER PRIMARY KEY,
name TEXT,
album TEXT
)
SQL
    DB[:conn].execute(sql)
  end

  def save
    # NOTE: The '?' question mark characters are used as placeholders to prevent SQL injections:
    sql = <<-SQL
INSERT INTO songs (name, album)
VALUES (?, ?)
SQL
    # NOTE: This line itself will run the above SQL command, and utilize the Class instance's values
    # for the 'name' and 'album' property values:
    # Insert the song:
    DB[:conn].execute(sql, self.name, self.album)

    # Get the song's 'id' property from the database and save it to the Ruby instance:
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]

    # Return the Ruby instance:
    self
  end

  def self.create(name:, album:)
    song = Song.new(name: name, album: album)
    song.save
  end

end
