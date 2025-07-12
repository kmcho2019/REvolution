module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);

    // mux_in[0] = c ? 1 : d;
    // 2-to-1 mux controlled by c: if c=0 output d else 1
    wire mux0_c0 = d;
    wire mux0_c1 = 1'b1;
    assign mux_in[0] = c ? mux0_c1 : mux0_c0;

    // mux_in[1] = 0 (constant zero)
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c ? d : 0;
    wire mux2_c0 = 1'b0;
    wire mux2_c1 = d;
    assign mux_in[2] = c ? mux2_c1 : mux2_c0;

    // mux_in[3] = d ? c : 1;
    wire mux3_d0 = 1'b1;
    wire mux3_d1 = c;
    assign mux_in[3] = d ? mux3_d1 : mux3_d0;

endmodule