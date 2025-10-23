module TopModule(
    input a,
    input b,
    input c,
    input d, // don't care
    output out
);

wire mux_in0, mux_in1, mux_in2, mux_in3;

assign mux_in0 = a | d;    // for c=0, b=0 (K-map cell values covered: 0 and 1 with d)
assign mux_in1 = 1'b1;     // for c=0, b=1 (all cells are 1 or d, output 1)
assign mux_in2 = 1'b1;     // for c=1, b=0 (all 1’s)
assign mux_in3 = a | b;    // for c=1, b=1 (K-map cells mostly 1 with some 0's but since d, we can simplify)

assign out = (c == 0) ? ((b == 0) ? mux_in0 : mux_in1)
                      : ((b == 0) ? mux_in2 : mux_in3);

endmodule