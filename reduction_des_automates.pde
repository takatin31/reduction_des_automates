import java.util.*;

int cpt = 0;
int k = 0;
TreeSet<Variable> list ;
Variable selectedVar;
boolean varIsSelected;
boolean reading = false;
String wordRead = "";
boolean drawingCourbe = false;
ArrayList<Iteration> iterations;
Iteration iterationInProcess = null;
boolean sameVar = false;
Variable axiome = null;
ArrayList<String> X;

void setup()
{
	list = new TreeSet<Variable>();
	iterations = new ArrayList<Iteration>();
	X = new ArrayList<String>();
	selectedVar = null;
	size(1200,600);
}

void draw()
{
	String dir ="";
	if (!reading)
	{
		initDrawing();
		textSize(13);

		
		TreeMap<Iteration, String> tempList = new TreeMap<Iteration, String>();

		for (Iteration i : iterations)
		{
			

			if (tempList.keySet().contains(i))
			{
				tempList.replace(i,tempList.get(i) + "/"+i.word);

			}
			else
			{
				tempList.put(i, i.word);
			}	
			
			stroke(255);
			noFill();

			if (i.begin != i.end)
			{
				beginShape();
					curveVertex(i.begin.x, i.begin.y);
					curveVertex(i.begin.x, i.begin.y);
					curveVertex(i.begin.x + (i.end.x - i.begin.x)/4, i.begin.y - map(i.end.x-i.begin.x, -1200, 1200, -100, 100));
					curveVertex(i.begin.x + (i.end.x - i.begin.x)*3/4, i.begin.y - map(i.end.x-i.begin.x, -1200, 1200, -100, 100));
					curveVertex(i.end.x, i.end.y);
					curveVertex(i.end.x, i.end.y);
				endShape();
			}
			else
			{
				beginShape();
					curveVertex(i.begin.x - 10, i.begin.y - 15);
					curveVertex(i.begin.x - 10, i.begin.y - 15);
					curveVertex(i.begin.x - 3, i.begin.y - 45);
					curveVertex(i.begin.x + 3, i.begin.y - 45);
					curveVertex(i.begin.x + 10, i.begin.y - 20);
					curveVertex(i.begin.x + 10, i.begin.y - 20);
				endShape();
			}
		}

		if (drawingCourbe)
		{

			stroke(255);
			noFill();
			beginShape();
				curveVertex(selectedVar.x, selectedVar.y);
				curveVertex(selectedVar.x, selectedVar.y);
				curveVertex(selectedVar.x + (mouseX - selectedVar.x)/4, selectedVar.y - map(mouseX-selectedVar.x, -1200, 1200, -100, 100));
				curveVertex(selectedVar.x + (mouseX - selectedVar.x)*3/4, selectedVar.y - map(mouseX-selectedVar.x, -1200, 1200, -100, 100));
				curveVertex(mouseX, mouseY);
				curveVertex(mouseX, mouseY);
			endShape();

		}

		if (varIsSelected)
		{
			selectedVar.x = mouseX;
			if (selectedVar.x > 1050)
				selectedVar.x = 1050;
			if (selectedVar.x < 20)
				selectedVar.x = 20;

			selectedVar.y = mouseY;
			if (selectedVar.y > 580)
				selectedVar.y = 580;
			if (selectedVar.y < 50)
				selectedVar.y = 50;
		}
	
		for (Iteration i : tempList.keySet())
		{
			if (i.begin.x < i.end.x)
				dir = " ->";
			else 
				dir = " <-";

			if (i.begin != i.end)
			{
				fill(255);
				noStroke();
				if (tempList.get(i) != "")
					text(tempList.get(i)+dir,i.begin.x + (i.end.x - i.begin.x)/2 , i.begin.y - map(i.end.x-i.begin.x, -1200, 1200, -100, 100) - 10);
				else 
					text("ɛ"+dir,i.begin.x + (i.end.x - i.begin.x)/2 , i.begin.y - map(i.end.x-i.begin.x, -1200, 1200, -100, 100) - 10);
			}
			else
			{
				fill(255);
				noStroke();
				if (tempList.get(i) != "")
					text(tempList.get(i),i.begin.x , i.begin.y - 50);
				else 
					text("ɛ",i.begin.x , i.begin.y - 50);
			}
		}

		for (Variable v : list)
		{
			v.draw();
		}
	}
	else
		readWord();
}



void initDrawing()
{
	background(0);
	fill(#bfbfbf);
	strokeWeight(2);
	stroke(255);
	rect(0, 0, 400, 30);
	rect(400, 0, 400, 30);
	rect(800, 0, 400, 30);
	noStroke();
	fill(0);
	textSize(20);
	text("Ajouter une variable", 100, 22);
	text("Reduction de l'Automate", 490, 22);
	text("Suppression de l'Automate", 890, 22);
  	fill(255);
	textSize(12);
	text("L'axiome", 1130, 75);
	text("Variable є ₣", 1130, 105);
	stroke(255);
	strokeWeight(1);
	fill(#1212FF);
	rect(1100, 60, 20, 20);
	fill(#FF0008);
	rect(1100, 90, 20, 20);
	fill(255);
	textSize(12);
	text("Developpé par Hammas Ali Chérif", 1000, 590);

}

void getAccessibleElement(Variable s)
{
	list.add(s);
	for (Iteration i : iterations)
	{
		if (i.begin == s && !list.contains(i.end))
		{
			getAccessibleElement(i.end);
		}
	}
		
}

void getCo_accessibleElement()
{
	TreeSet<Variable> list2 = new TreeSet<Variable>();
	for (Variable v : list)
	{	
		if (v.end)
		{
			list2.add(v);
		}
	}
	
	list = new TreeSet<Variable>();
	for (Variable v : list2)
	{	
		getCo_accessibleElement2(v);
	}
}

void getCo_accessibleElement2(Variable s)
{
	list.add(s);
	for (Iteration i : iterations)
	{			
		if (i.end == s && !list.contains(i.begin))
		{
			getCo_accessibleElement2(i.begin);
		}
	}
}


void clearIterations()
{
	ArrayList<Iteration> iterations2 = new ArrayList<Iteration>();
	for (Iteration i : iterations)
	{
		if (list.contains(i.begin) && list.contains(i.end))
		{
			iterations2.add(i);
		}
	}
	iterations = new ArrayList<Iteration>();
	iterations = iterations2;
}



void keyPressed()
{
	if (reading)
	{
		if (key != '\n')
		{
			if (wordRead.length() < 10 && ((key >= 'a' && key <= 'z') || (key >= '0' && key <= '9')))
				wordRead += key;
			else 
			{
				if (key == 8 && wordRead.length() > 0) 
				{
					wordRead = wordRead.substring(0, wordRead.length()-1);
				}
			}
		}
		else 
		{
			iterationInProcess.word = wordRead;
			X.add(wordRead);
			iterations.add(iterationInProcess);
			reading = false;
			wordRead = "";  
		}
	}
}

void mousePressed()
{
	if ((mouseButton == LEFT))
	{
		if (mouseX > 0 && mouseX < 400 && mouseY > 0 && mouseY < 30)
		{
			addVar();					
		}
		else 
		{	
			if (mouseX > 400 && mouseX < 800 && mouseY > 0 && mouseY < 30) 
			{
				
				list = new TreeSet<Variable>();

				getAccessibleElement(axiome);
				clearIterations();
				getCo_accessibleElement();
				clearIterations();
				
				
				
			}
			else
			{ 
				if (mouseX > 800 && mouseX < 1200 && mouseY > 0 && mouseY < 30) 
				{
					cpt = 0;
					list = new TreeSet<Variable>();
					wordRead ="";
					varIsSelected = false;
					selectedVar = null;
					drawingCourbe = false;
					iterations = new ArrayList<Iteration>();
				}
			}
		}
	}

	boolean found = false;
	for (Variable v : list)
	{
		if (mouseX < v.x + 20 && mouseX > v.x - 20 && mouseY < v.y + 20 && mouseY > v.y - 20)
		{
			
			if(mouseButton == LEFT)
				varIsSelected = !varIsSelected;
			else
			if (mouseButton == RIGHT) 
			{
				if (drawingCourbe)
				{
					iterationInProcess = new Iteration(selectedVar, v, "");
					reading = true;
				}
				drawingCourbe = !drawingCourbe;
			}

			selectedVar = v;
			found = true;
			break;
		}
	}

	if (drawingCourbe && !found)
	{
		drawingCourbe = false;
		reading = false;
		selectedVar.end = true;
	}

	if (!varIsSelected && found)
	{
		for (Variable v : list)
		{
			if (v != selectedVar && dist(v.x, v.y, selectedVar.x, selectedVar.y) < 40)
			{
				if (selectedVar.x < v.x)
					selectedVar.x -= 40;
				else
					selectedVar.x += 40;

				if (selectedVar.y < v.y)
					selectedVar.y -= 40;
				else
					selectedVar.y += 40;
			}
		}
	}
}

void addVar()
{
	int x = (cpt%25)*40 + 20;
	int y = (cpt/25)*40 + 55;
	Variable v = new Variable("S"+cpt, x, y);
	if (cpt == 0)
	{
		v.begin = true;
		axiome = v;
	}
	list.add(v);
	cpt ++;
}

void readWord()
{
	background(#B3B3B3);
	fill(#1D1D1D);
	stroke(255);
	strokeWeight(2);
	rect(450, 270, 300, 60);
	fill(255);
	textSize(15);
	text("Entrer le mot a ajouter", 510, 290);
	fill(#2300FF);
	text(wordRead, 600 - wordRead.length()*3, 320);
}
