module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Minimum Sum-of-Products (SOP) form for out_sop
assign out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

// For out_pos, considering the conditions, we directly implement the simplified form
// Since the input conditions for 3, 8, 11, and 12 never occur, we focus on the given conditions
// The logic-0 conditions directly translate to a simpler form considering all inputs
assign out_pos = ~( (a & ~b & ~c & ~d) | (~a & ~b & ~c & ~d) | (~a & ~b & c & ~d) | (~a & ~b & ~c & d) | (~a & b & ~c & ~d) | (~a & b & c & ~d) | (~a & ~b & c & d) | (a & ~b & c & ~d) | (a & ~b & ~c & d) | (~a & b & ~c & d));

endmodule