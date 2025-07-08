module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// First, assign the minterms for numbers 2,7,15
// Numbers:
// 2 = 0 0 1 0  (a=0,b=0,c=1,d=0)
// 7 = 0 1 1 1  (a=0,b=1,c=1,d=1)
// 15= 1 1 1 1  (a=1,b=1,c=1,d=1)

// Simplify SOP:
// Minterms:
// 2: !a & !b & c & !d
// 7: !a & b & c & d
// 15: a & b & c & d

// Grouping terms for SOP minimal:
// Common factor c:
// ( !a & !b & c & !d ) + ( !a & b & c & d ) + ( a & b & c & d )

// Try sum of products minimal:
// Observe that 7 and 15 share b & c & d, and 2 is separate.

// So:
// out_sop = (!a & !b & c & !d) + (b & c & d)

// For POS, complement of this function is the zeros for 0,1,4,5,6,9,10,13,14.

// Alternatively, write out POS from zeros.

// Final implementation:

assign out_sop = ((!a) & (!b) & c & (!d)) | (b & c & d);

// To find POS form, the expression equals zero for these numbers:
// zeros: 0(0000),1(0001),4(0100),5(0101),6(0110),9(1001),10(1010),13(1101),14(1110)

// Write each zero as maxterm (sum term) and multiply all:

// For example, 0 = 0000 => (a + b + c + d)
// 1 = 0001 => (a + b + c + !d)
// 4 = 0100 => (a + !b + c + d)
// 5 = 0101 => (a + !b + c + !d)
// 6 = 0110 => (a + !b + !c + d)
// 9 = 1001 => (!a + b + c + !d)
// 10= 1010 => (!a + b + !c + d)
// 13= 1101 => (!a + !b + c + !d)
// 14= 1110 => (!a + !b + !c + d)

// The minimal POS is found via Karnaugh map or Boolean algebra:
// By examining the map, the minimal POS is:
// out_pos = (a + b + c) & (a + b + !d) & (a + !b + d)

// We'll implement this minimal POS expression.

assign out_pos = (a | b | c) & (a | b | ~d) & (a | ~b | d);

endmodule