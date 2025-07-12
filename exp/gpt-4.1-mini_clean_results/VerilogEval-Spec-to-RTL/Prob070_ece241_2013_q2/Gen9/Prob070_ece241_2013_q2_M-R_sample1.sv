module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

wire [3:0] in = {a,b,c,d};

// out_sop = 1 for inputs 2,7,15
assign out_sop = (in == 4'd2) | (in == 4'd7) | (in == 4'd15);

// The zeros are 0,1,4,5,6,9,10,13,14
// Minimal POS from these zeros (maxterms):
// Maxterms correspond to zeros (in decimal):
// 0  = 0000 -> (a + b + c + d)
// 1  = 0001 -> (a + b + c + ~d)
// 4  = 0100 -> (a + ~b + c + d)
// 5  = 0101 -> (a + ~b + c + ~d)
// 6  = 0110 -> (a + ~b + ~c + d)
// 9  = 1001 -> (~a + b + ~c + ~d)
// 10 = 1010 -> (~a + b + c + ~d)
// 13 = 1101 -> (~a + ~b + c + ~d)
// 14 = 1110 -> (~a + ~b + ~c + d)

// Minimizing these maxterms results in this minimal POS:
// out_pos = (a + b + c + d) & (a + ~b + ~c + d) & (~a + b + c + ~d)

// This minimal POS covers all zeros and excludes 2,7,15 as ones.

assign out_pos = 
    (a | b |  c |  d) &
    (a | ~b | ~c |  d) &
    (~a | b |  c | ~d);

endmodule