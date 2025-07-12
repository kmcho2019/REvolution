module TopModule (
    input  wire c,
    input  wire d,
    output wire [3:0] mux_in
);
    // For each fixed ab, define mux_in[ab_index] = f(c,d)
    // K-map reminder:
    // ab=00 (mux_in[0]): cd=00=0,01=1,11=1,10=1
    // ab=01 (mux_in[1]): all 0
    // ab=11 (mux_in[2]): cd=11=1, others 0
    // ab=10 (mux_in[3]): cd=00=1,01=0,11=1,10=1

    // Implement each function using only 2-to-1 muxes (?:), no gates.

    // mux_in[0]:
    // c d | out
    // 0 0 | 0
    // 0 1 | 1
    // 1 0 | 1
    // 1 1 | 1
    // Observe: if c=0 output d else 1
    assign mux_in[0] = (c) ? 1'b1 : d;

    // mux_in[1]: always 0
    assign mux_in[1] = 1'b0;

    // mux_in[2]:
    // c d | out
    // 0 0 |0
    // 0 1 |0
    // 1 0 |0
    // 1 1 |1
    // This is c AND d, but no AND allowed.
    // Implement as: if c=1 output d else 0
    assign mux_in[2] = (c) ? d : 1'b0;

    // mux_in[3]:
    // c d | out
    // 0 0 |1
    // 0 1 |0
    // 1 0 |1
    // 1 1 |1
    // If c=0 output ~d, if c=1 output 1
    // No NOT gate, implement ~d as (d ? 0 :1)
    assign mux_in[3] = (c) ? 1'b1 : ((d) ? 1'b0 : 1'b1);

endmodule