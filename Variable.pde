class Variable implements Comparable<Variable>
{
	String name;
	int x;
	int y;
	boolean begin;
	boolean end;

	Variable(String name, int x, int y)
	{
  	this.x = x;
  	this.y = y;
  	this.name= name;
  	this.begin = false;
  	this.end = false;
	}

	void draw()
	{
		fill(0);
		if (begin)
		{
			stroke(#1212FF);
		}
		else 
		{
			stroke(255);
		}

		strokeWeight(2);
		ellipse(this.x, this.y, 40, 40);

		if (end)
		{
			stroke(#FF0008);
			ellipse(this.x, this.y, 33, 33);
		}

		fill(255);
		noStroke();
		textSize(14);
		if (name.length() < 3)
			text(name,this.x-5, this.y+5);
		else
			text(name,this.x-10, this.y+5);
	}

	public int compareTo(Variable v)
	{
		return (this.name.compareTo(v.name));
	}
}
