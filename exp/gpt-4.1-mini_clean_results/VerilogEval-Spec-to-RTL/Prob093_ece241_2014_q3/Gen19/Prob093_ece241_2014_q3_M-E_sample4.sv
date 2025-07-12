module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // Implement ~d using a 2-to-1 mux with selector d
    wire not_d;
    assign not_d = d ? 1'b0 : 1'b1;

    // mux_in[0] = c ? 1 : d
    wire mux0_c0 = d;
    wire mux0_c1 = 1'b1;
    assign mux_in[0] = c ? mux0_c1 : mux0_c0;

    // mux_in[1] = 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c ? ~d : 0
    wire mux2_c0 = 1'b0;
    wire mux2_c1 = not_d;
    assign mux_in[2] = c ? mux2_c1 : mux2_c0;

    // mux_in[3] = c ? 1 : ~d
    wire mux3_c0 = not_d;
    wire mux3_c1 = 1'b1;
    assign mux_in[3] = c ? mux3_c1 : mux3_c0;

endmodule