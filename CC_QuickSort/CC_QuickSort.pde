//Have 3 modes.
//Mode 1: (The first pointer is moving)
//Check whether the positions of the pointers is equal if yes go to Mode 3.
//Check whether the current element at the pointer position is bigger than the pivot.
//If yes mark that position and go to Mode 2:
//If no move the fist pointer further forwards
//Mode 2: (The first pointer is set, the second one is moving)
//Check whether the positions of the pointers is equal if yes go to Mode 3.
//Check whether the current element at the pointer position is smaller than the pivot.
//If yes swap the marked position with the one pointed at.
//If no move the second pointer further backwards
//Mode 3: (The pointers met)
//Swap the current position of the first pointer and pivot
//To the list of awaiting indices add two new entries: from min to pivot-1 and from pivot+1 to max.
//Pick new pointers from the list of awaiting indices and erase that entry.

//Cases:
//The first pointer marks a number >>
//The second pointer finds a number >> Swap and continue
//The second pointer meets the first pointer >> Go to Mode 3
//The first pointer does not mark a number >>
//No numbers are larger than Pivot >> do not swap (Pivot is the largest number). Add an entry to the awaiting indices from min to pointer1-1
//The number of the second pointer is bigger than the Pivot >> Swap with the pivot and add an entry to the awaiting indices from min to pointer1-2 and pointer1+1 and max

import java.lang.Comparable;
import java.util.List;
import java.util.Arrays;

Comparable[] comparableArray;
Comparable pivotElement;
Comparable currentElement;
List<Indices> awaitingIndices = new ArrayList();
Indices currentIndices;

Integer pointer1;
Integer pointer2;
Integer mode;

boolean somethingChanged = true;

void setup() {
  size(2500, 600);
  frameRate(width);
  
  comparableArray = new Integer[width];

  for (int i = 0; i < comparableArray.length; i++) {
    comparableArray[i] = (int) random(height);
    //comparableArray[i] = height - (1+i)*100-50;
  }

  currentIndices = new Indices(0, comparableArray.length-1);
  pointer1 = 0;
  pointer2 = comparableArray.length-2;
  pivotElement = comparableArray[currentIndices.endIndex];
  mode = 1;
}

void draw() {
  if (somethingChanged) {
    somethingChanged = false;
    background(0);
    int linewidth = width/comparableArray.length;
    if (linewidth > 1) {
      for (int i = 0; i < comparableArray.length; i++) {
        stroke(255);
        fill(255);
        if (i<comparableArray.length-1) {
          if(comparableArray[i].compareTo(comparableArray[i+1]) == 1){
            println(comparableArray[i], comparableArray[i+1]);
            stroke(255, 0, 0);
            fill(255, 0, 0);
          }
        }

        rect(i*linewidth, height - (int) comparableArray[i], linewidth, (int) comparableArray[i]);
      }
    } else {
      for (int i = 0; i < comparableArray.length; i++) {
        stroke(255);
        if (i<comparableArray.length-1 && comparableArray[i].compareTo(comparableArray[i+1]) == 1) {
          stroke(255, 0, 0);
        }

        line(i, height, i, height - (int) comparableArray[i]);
      }
    }
  }

  //stepwise quicksort algorithm
  switch(mode) {
  case 1:
    if (pointersMet()) {
      mode = 3;
      break;
    }

    currentElement = comparableArray[pointer1];
    if (currentElement.compareTo(pivotElement) == 1) {
      mode = 2;
      break;
    }
    pointer1++;
    break;

  case 2:
    if (pointersMet()) {
      mode = 3;
      break;
    }

    currentElement = comparableArray[pointer2];
    if (currentElement.compareTo(pivotElement) == -1) {
      swap(comparableArray, pointer1, pointer2);
      mode = 1;
      break;
    }
    pointer2--;
    break;
  case 3:
    workMode3();
    break;

  default:
    break;
  }
}



//-------------Helpers-------------

void workMode3() {
  //final swaps
  Comparable elementAtOne = comparableArray[pointer1];
  if (elementAtOne.compareTo(pivotElement) == 1) {
    swap(comparableArray, pointer1, currentIndices.endIndex);
    if (currentIndices.startIndex < pointer1 - 1) {
      awaitingIndices.add(new Indices(currentIndices.startIndex, pointer1 - 1));
    }
    if (pointer1 + 1 < currentIndices.endIndex) {
      awaitingIndices.add(new Indices(pointer1 + 1, currentIndices.endIndex));
    }
  } else {
    if (currentIndices.startIndex < pointer1) {
      awaitingIndices.add(new Indices(currentIndices.startIndex, pointer1));
    }
  }
  //if (currentIndices.endIndex > pointer1+1)
  //  awaitingIndices.add(new Indices(pointer1+1, currentIndices.endIndex));

  //new Indices
  if (!awaitingIndices.isEmpty()) {

    currentIndices = awaitingIndices.get(0);
    awaitingIndices.remove(0);

    pointer1 = currentIndices.startIndex;
    pointer2 = currentIndices.endIndex-1;
    pivotElement = comparableArray[currentIndices.endIndex];

    mode = 1;
  }
}

boolean pointersMet() {
  return pointer1.equals(pointer2);
}

Object[] swap(Object[] array, int index1, int index2) {
  somethingChanged = true;
  
  Object placeholder = array[index1];
  array[index1] = array[index2];
  array[index2] = placeholder;
  return array;
}

class Indices {
  int startIndex;
  int endIndex;

  public Indices(int startIndex, int endIndex) {
    this.startIndex = startIndex;
    this.endIndex = endIndex;
  }

  int getStartIndex() {
    return startIndex;
  }

  int getEndIndex() {
    return endIndex;
  }
}
