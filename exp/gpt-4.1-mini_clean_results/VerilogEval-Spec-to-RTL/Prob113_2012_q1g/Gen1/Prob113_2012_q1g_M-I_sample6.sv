module TopModule(
    input  [3:0] x,
    output      f
);

// Extract rows and columns according to problem statement
wire [1:0] row = x[3:2];
wire [1:0] col = x[1:0];

// Karnaugh map (row x col):
//          00 01 11 10  (col)
// 00       1  0  0  1
// 01       0  0  0  0
// 11       1  1  1  0
// 10       1  1  0  1

// To simplify, let's write minterms where f=1 (row,col):
// (00,00) = x[3:2]=00, x[1:0]=00 = 4'b0000
// (00,10) = 00, 10 = 4'b0010
// (11,00) = 11, 00 = 4'b1100
// (11,01) = 11, 01 = 4'b1101
// (11,11) = 11, 11 = 4'b1111
// (10,00) = 10, 00 = 4'b1000
// (10,01) = 10, 01 = 4'b1001
// (10,10) = 10, 10 = 4'b1010

// Now derive the minimized boolean expression:
// Let's define inputs as:
// A = x[3], B = x[2], C = x[1], D = x[0]

// Let's write minterms for f=1 in (A,B,C,D):
// 0000 -> A=0,B=0,C=0,D=0
// 0010 -> A=0,B=0,C=1,D=0
// 1100 -> A=1,B=1,C=0,D=0
// 1101 -> A=1,B=1,C=0,D=1
// 1111 -> A=1,B=1,C=1,D=1
// 1000 -> A=1,B=0,C=0,D=0
// 1001 -> A=1,B=0,C=0,D=1
// 1010 -> A=1,B=0,C=1,D=0

// Observing the pattern, let's try to find groups:

// Group 1: Row=11 (A=1,B=1) and cols 00,01,11 except 10 (f=0)
// => When A=1,B=1: f=1 for (C,D)=00,01,11
// That is: (A&B) & ((~C & ~D) | (~C & D) | (C & D)) = (A&B) & (~C | D)

// Group 2: Row=10 (A=1,B=0), cols 00,01,10 are 1, but not 11
// (A & ~B) & ((~C & ~D) | (~C & D) | (C & ~D)) = (A & ~B) & (~C | ~D)

// Group 3: Row=00 (A=0,B=0), cols 00 and 10 are 1
// (~A & ~B) & ((~C & ~D) | (C & ~D)) = (~A & ~B) & (~D)

// Let's write the expression:

// f = (A & B & (~C | D)) 
//   | (A & ~B & (~C | ~D))
//   | (~A & ~B & ~D);

assign f = (A & B & (~C | D))
         | (A & ~B & (~C | ~D))
         | (~A & ~B & ~D);

endmodule