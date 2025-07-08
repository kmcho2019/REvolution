module Mux2to1(
    input d0,
    input d1,
    input s,
    output y
);
    assign y = s ? d1 : d0;
endmodule

module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);
    wire mux_in0_level1, mux_in0_level0;
    wire mux_in3_level1, mux_in3_level0;
    wire mux_in2_level1, mux_in2_level0;

    // mux_in[0] truth table by cd:
    // cd=00=0,01=1,11=1,10=1
    // Implement as mux_in[0] = MUX c (1, MUX d(1,0))
    Mux2to1 mux0_level0(.d0(1'b0), .d1(1'b1), .s(d), .y(mux_in0_level0));
    Mux2to1 mux0_level1(.d0(1'b1), .d1(1'b1), .s(d), .y(mux_in0_level1));
    Mux2to1 mux0(.d0(mux_in0_level0), .d1(mux_in0_level1), .s(c), .y(mux_in[0]));

    // mux_in[1] all zeros
    assign mux_in[1] = 1'b0;

    // mux_in[2] cd=00=0,01=0,11=1,10=0
    // mux_in[2] = MUX c (MUX d(0,1), MUX d(0,0))
    Mux2to1 mux2_level0(.d0(1'b0), .d1(1'b1), .s(d), .y(mux_in2_level0));
    Mux2to1 mux2_level1(.d0(1'b0), .d1(1'b0), .s(d), .y(mux_in2_level1));
    Mux2to1 mux2(.d0(mux_in2_level1), .d1(mux_in2_level0), .s(c), .y(mux_in[2]));

    // mux_in[3] cd=00=1,01=0,11=1,10=1
    // mux_in[3] = MUX c (MUX d(1,1), MUX d(0,1))
    Mux2to1 mux3_level0(.d0(1'b1), .d1(1'b0), .s(d), .y(mux_in3_level0));
    Mux2to1 mux3_level1(.d0(1'b1), .d1(1'b1), .s(d), .y(mux_in3_level1));
    Mux2to1 mux3(.d0(mux_in3_level0), .d1(mux_in3_level1), .s(c), .y(mux_in[3]));

endmodule