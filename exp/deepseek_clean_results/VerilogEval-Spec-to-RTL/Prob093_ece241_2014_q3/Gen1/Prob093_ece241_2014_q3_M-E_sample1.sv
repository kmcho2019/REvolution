module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // mux_in[0] = ~(c & ~d) = c ? 1 : d
    wire mux0_out;
    assign mux0_out = c ? 1'b1 : d;

    // mux_in[1] = constant 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c & d = c ? d : 0
    wire mux2_out;
    assign mux2_out = c ? d : 1'b0;

    // mux_in[3] = ~d | (c & d) = c ? 1'b1 : ~d
    wire mux3_out;
    assign mux3_out = c ? 1'b1 : ~d;

    // Combine all outputs
    assign mux_in = {mux3_out, mux2_out, 1'b0, mux0_out};

endmodule