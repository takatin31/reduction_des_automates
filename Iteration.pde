class Iteration implements Comparable<Iteration>
{
	Variable begin;
	Variable end;
	String word;


	Iteration(Variable a, Variable b, String s)
	{
		begin = a;
		end = b;
		word = s;
	}

	public int compareTo(Iteration i)
	{
		if (i.begin == this.begin)
		{
			return this.end.compareTo(i.end);
		}
		else
		{
			return this.begin.compareTo(i.begin);
		}
	}
}
