module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

// Corrected implementation for SOP
assign out_sop = (b & ~a & ~c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Corrected implementation for POS, considering the complement of the desired output
// The numbers 0, 1, 4, 5, 6, 9, 10, 13, and 14 should produce a logic-0
assign out_pos = ~( (~a & ~b & ~c & ~d) | ( ~a & b & ~c & ~d) | ( ~a & ~b & c & ~d) | ( ~a & ~b & ~c & d) | 
                   ( ~a & b & c & ~d) | ( ~a & b & ~c & d) | ( ~a & ~b & c & d) | ( ~a & ~b & ~c & ~d & ~b & ~a & ~c & d) | 
                   ( a & ~b & ~c & ~d) | ( a & ~b & c & ~d) | ( a & b & ~c & ~d) | ( a & ~b & ~c & d));

endmodule