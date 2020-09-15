from sqlalchemy import Column, Integer, String
from database import Base

class Snack(Base):
    __tablename__ = 'snacks'

    id = Column(Integer, primary_key=True)
    name = Column(String(50), unique=True)
    speech = Column(String(2048), unique=True)
    image_url = Column(String(2048), unique=True)

    def __repr__(self):
        return '<Snack %r>' % (self.name)

class Drink(Base):
    __tablename__ = 'drinks'

    id = Column(Integer, primary_key=True)
    name = Column(String(50), unique=True)
    speech = Column(String(2048), unique=True)
    image_url = Column(String(2048), unique=True)

    def __repr__(self):
        return '<Drink %r>' % (self.name)
