module mux2to1(input sel, input in0, input in1, output out);
    assign out = sel ? in1 : in0;
endmodule

module TopModule(input c, input d, output [3:0] mux_in);
    wire not_d;
    // not_d = ~d implemented by 2-to-1 mux with d as sel, inputs 1,0
    mux2to1 not_d_mux(.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d));

    // mux_in[0] = c ? 1 : d
    wire mux0;
    mux2to1 mux0_inst(.sel(c), .in0(d), .in1(1'b1), .out(mux0));

    // mux_in[1] = 0
    wire mux1 = 1'b0;

    // mux_in[2] = c & d = c ? d : 0
    wire mux2;
    mux2to1 mux2_inst(.sel(c), .in0(1'b0), .in1(d), .out(mux2));

    // mux_in[3] = c ? 1 : ~d
    wire mux3;
    mux2to1 mux3_inst(.sel(c), .in0(not_d), .in1(1'b1), .out(mux3));

    assign mux_in = {mux3, mux2, mux1, mux0};
endmodule