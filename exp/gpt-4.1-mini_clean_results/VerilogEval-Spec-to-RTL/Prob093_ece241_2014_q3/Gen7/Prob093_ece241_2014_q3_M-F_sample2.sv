// 2-to-1 multiplexer module: Y = S ? I1 : I0
module Mux2to1 (
    input  I0,
    input  I1,
    input  S,
    output Y
);
    assign Y = S ? I1 : I0;
endmodule

module TopModule(
    input  c,
    input  d,
    output [3:0] mux_in
);

    // For mux_in[0] (ab=00):
    // cd=00->0,01->1,11->1,10->1
    // f0 = d ? 1 : 0
    // f1 = 1
    wire f0_0, f1_0;
    Mux2to1 mux0_d (.I0(1'b0), .I1(1'b1), .S(d), .Y(f0_0));
    assign f1_0 = 1'b1;
    Mux2to1 mux0_c (.I0(f0_0), .I1(f1_0), .S(c), .Y(mux_in[0]));

    // For mux_in[1] (ab=01):
    // always 0
    assign mux_in[1] = 1'b0;

    // For mux_in[2] (ab=11):
    // cd=00->0,01->0,11->1,10->0
    // f0 = 0
    // f1 = d ? 1 : 0
    wire f0_2, f1_2;
    assign f0_2 = 1'b0;
    Mux2to1 mux2_d (.I0(1'b0), .I1(1'b1), .S(d), .Y(f1_2));
    Mux2to1 mux2_c (.I0(f0_2), .I1(f1_2), .S(c), .Y(mux_in[2]));

    // For mux_in[3] (ab=10):
    // cd=00->1,01->0,11->1,10->1
    // f0 = d ? 0 : 1
    // f1 = 1
    wire f0_3, f1_3;
    Mux2to1 mux3_d (.I0(1'b1), .I1(1'b0), .S(d), .Y(f0_3));
    assign f1_3 = 1'b1;
    Mux2to1 mux3_c (.I0(f0_3), .I1(f1_3), .S(c), .Y(mux_in[3]));

endmodule