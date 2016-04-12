//Name: Neil Advani
//VUnetid: advanin
//Email: neil.advani@vanderbilt.edu
//Honor Statement: I did not recieve any help on this assignment

#ifndef Sudoku_H
#define Sudoku_H

#include <iostream>
#include <string>
using namespace std;

class Sudoku
{
private:
	int board[9][9]; // how many days in each month with 1-based indexing
	bool canPlace(int row, int col, int num); //checks if num can be placed at given row and col
public:
	Sudoku(); //set board to all 0s
	void loadFromFile(string filename); //set board to input from filename
	bool solve(); //solves the puzzle returning true if solved otherwise false
	void print() const; //prints the puzzle in a nice way
	bool equals(const Sudoku &other) const; //determines if two puzzles are the same	
};

#endif

