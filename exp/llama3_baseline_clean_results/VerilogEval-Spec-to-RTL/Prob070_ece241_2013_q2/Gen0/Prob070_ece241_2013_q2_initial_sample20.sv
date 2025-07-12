module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Sum of Products (SOP) implementation
assign out_sop = (~a & b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

// Product of Sums (POS) implementation
// Directly implementing POS requires considering the complement of the
// missing minterms or using a K-map for simplification. Given the system's
// constraints and the need for minimization, let's focus on the concept
// and ensure the code reflects the correct logic implementation.
assign out_pos = ~( (a & ~b & ~c & ~d) | (~a & ~b & ~c & d) | (~a & ~b & c & ~d) | (~a & ~b & c & d) |
                   (~a & b & ~c & ~d) | (~a & b & ~c & d) | (~a & b & c & ~d) |
                   (a & ~b & ~c & ~d) | (a & ~b & ~c & d) | (a & ~b & c & d) |
                   (a & b & ~c & ~d) );

endmodule