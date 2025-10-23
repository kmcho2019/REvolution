module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // Internal wires for 2-to-1 mux outputs for mux_in[0] and mux_in[3]
    wire mux0_c0; // c=0 branch for mux_in[0]
    wire mux0_c1; // c=1 branch for mux_in[0]

    wire mux2_c0; // c=0 branch for mux_in[2]
    wire mux2_c1; // c=1 branch for mux_in[2]

    wire mux3_d0; // d=0 branch for mux_in[3]
    wire mux3_d1; // d=1 branch for mux_in[3]

    // mux_in[0] = c ? 1'b1 : d;
    assign mux0_c0 = d;
    assign mux0_c1 = 1'b1;
    assign mux_in[0] = c ? mux0_c1 : mux0_c0;

    // mux_in[1] = 1'b0; // no logic needed, constant 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c ? d : 1'b0;
    assign mux2_c0 = 1'b0;
    assign mux2_c1 = d;
    assign mux_in[2] = c ? mux2_c1 : mux2_c0;

    // mux_in[3] = d ? c : 1'b1;
    assign mux3_d0 = 1'b1;
    assign mux3_d1 = c;
    assign mux_in[3] = d ? mux3_d1 : mux3_d0;

endmodule