///Name: Neil Advani
//VUnetid: advanin
//Email: neil.advani@vanderbilt.edu
//Honor Statement: I did not recieve any help on this assignment


// CS270 Vanderbilt University
// Prof. Roth

#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <stdlib.h>
#include <stdexcept>
#include "Sudoku.h"
using namespace std;

// Constructor
//loops through the board and sets all values to 0
//post: Sudoku object has been created
Sudoku::Sudoku()    // default constructor - set all values to 0
{	
	for (int i = 0; i < 9; i++)
		for (int j = 0; j < 9; j++)
			board[i][j] = 0;
}

//Load from file
//input: filename containing sudoku board
//sets values of file to the board
//pre:sudoku object is created and filename has an acceptable input
//post:sudoku board has been updated to look like file
void Sudoku::loadFromFile(string filename)
{
	//opens file
	ifstream mySudokuFile;
	mySudokuFile.open(filename, ios_base::in);

	//loops through each position and sets it to file value
	
	for (int i = 0; i < 9; i++)
	{
		for (int j = 0; j < 9; j++)
		{
			int val;
			mySudokuFile >> val;
			board[i][j] = val;
		}
	}
	//close file
	mySudokuFile.close();
}

// Print
// prints the sudoku board in a nice way
//pre: sudoku board has been initialized
//post: sudoku board has been printed out nicely
void Sudoku::print() const
{
	for (int i = 0; i < 9; i++)
	{
		for (int j = 0; j < 9; j++)
		{
			//if end of box horizontally
			if (j == 3 || j == 6)
				cout << "| ";

			cout << board[i][j] << " ";
		}
		cout << endl;
		//if end of box vertically
		if (i == 2 || i == 5)
			cout << "----" << "--+--" << "----" << "-+--" << "----" << endl;
	}
}

//equals
//input: Sudoku object
//returns true if boards are the same, else false
//pre: sudoku object has been initialized and other board is a sudoku object
//post: returns true if objects are equal else false
bool Sudoku::equals(const Sudoku &other) const
{
	for (int i = 0; i < 9; i++)
		for (int j = 0; j < 9; j++)
			if (board[i][j] != other.board[i][j])
				return false;
	return true;
}

//Solve
//solves the puzzle, returning true if solved, otherwise false
//pre: board has been initialized
//post: board is solved and returns true or determied to be unsolvable and returns false
bool Sudoku::solve()
{
	int row = -1, col = -1;  //variables for current row/column
	
	for (int i = 0; i < 9; i++)
	{
		for (int j = 0; j < 9; j++)
		{
			if (board[i][j] == 0)
			{
				row = i;
				col = j;
				goto endLoop;
			}
		}
	}

	endLoop:
	//if no empty spots, solution is made
	if (row == -1 && col == -1)
		return true;

	//try each number from 1-9
	for (int num = 1; num < 10; num++)
	{
		//make assignment if safe
		if (canPlace(row, col, num))
		{
			//make assignment
			board[row][col] = num;

			//recursive call to check if solved
			if (solve())
				//done
				return true;

			//didnt work, undo assignment
			board[row][col] = 0;
		}
	}
	return false;
}

//isSafe
//checks if given num can be placed in given spot
//pre: row col and num are all ints within range and board has been initialized
//post: returns true if spot is ok else false
bool Sudoku::canPlace(int row, int col, int num)
{
	//check vertically/horizontally via loops and constant row/col
	for (int eachCol = 0; eachCol < 9; eachCol++)
	{
		if (board[row][eachCol] == num)
			return false;
	}
	for (int eachRow = 0; eachRow < 9; eachRow++)
	{
		if (board[eachRow][col] == num)
			return false;
	}

	//check the 3x3 box for this num
	int rowBoxStart = row - row % 3;
	int colBoxStart = col - col % 3;
	for (int i = 0; i < 3; i++)
		for (int j = 0; j < 3; j++)
			if (board[rowBoxStart + i][colBoxStart + j] == num)
				return false;
	return true;
}