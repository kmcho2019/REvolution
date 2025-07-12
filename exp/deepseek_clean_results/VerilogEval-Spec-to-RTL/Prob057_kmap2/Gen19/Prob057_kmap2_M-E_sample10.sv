module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Phase-controlled signals
wire a_phase = a ^ d;
wire b_phase = b ^ c;

// Weighted voting mechanism
wire c0_vote = (a | b) & ~c;
wire a1_vote = (c | d) & a;

// Edge case handling
wire edge_case = (a_phase & b_phase) | (~a & ~b & c & d);

// Final output
assign out = c0_vote | a1_vote | edge_case;

endmodule