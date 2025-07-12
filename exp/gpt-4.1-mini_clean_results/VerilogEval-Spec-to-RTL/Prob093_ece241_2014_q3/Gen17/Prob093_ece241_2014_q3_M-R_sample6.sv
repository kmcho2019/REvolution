// 2-to-1 multiplexer module
module Mux2to1 (
    input sel,
    input in0,
    input in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // mux_in[0] = d ? 1 : c
    wire mux0_lower; // c
    wire mux0_upper; // 1
    assign mux0_lower = c;
    assign mux0_upper = 1'b1;
    Mux2to1 mux0 (.sel(d), .in0(mux0_lower), .in1(mux0_upper), .out(mux_in[0]));

    // mux_in[1] = 0 (constant zero)
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c ? d : 0
    wire mux2_lower; // 0
    wire mux2_upper; // d
    assign mux2_lower = 1'b0;
    assign mux2_upper = d;
    Mux2to1 mux2 (.sel(c), .in0(mux2_lower), .in1(mux2_upper), .out(mux_in[2]));

    // mux_in[3] = d ? c : 1
    wire mux3_lower; // 1
    wire mux3_upper; // c
    assign mux3_lower = 1'b1;
    assign mux3_upper = c;
    Mux2to1 mux3 (.sel(d), .in0(mux3_lower), .in1(mux3_upper), .out(mux_in[3]));

endmodule