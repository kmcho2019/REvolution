module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0]: ab=00 (0,1,1,1)
    wire mux0_sel = ~(c | d);  // Select 0 when cd=00
    wire mux0_in1 = c | d;     // Otherwise OR of c and d
    assign mux_in[0] = mux0_sel ? 1'b0 : mux0_in1;

    // mux_in[1]: ab=01 (always 0)
    assign mux_in[1] = 1'b0;

    // mux_in[2]: ab=11 (0,0,1,0)
    wire mux2_sel = c;         // Select d when c=1
    assign mux_in[2] = mux2_sel ? d : 1'b0;

    // mux_in[3]: ab=10 (1,0,1,1)
    wire mux3_sel = ~(c | d);  // Select 1 when cd=00
    wire mux3_in1 = c | ~d;    // Otherwise OR of c and ~d
    assign mux_in[3] = mux3_sel ? 1'b1 : mux3_in1;

endmodule