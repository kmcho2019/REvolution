module mux2(input sel, input d0, input d1, output y);
    assign y = sel ? d1 : d0;
endmodule

module TopModule(input c, input d, output [3:0] mux_in);
    wire not_d;

    // NOT_d implemented via mux2: select=d, inputs: 1 and 0 to invert d
    mux2 inv_d (.sel(d), .d0(1'b1), .d1(1'b0), .y(not_d));

    // mux_in[0] = mux2 select c: 0->d, 1->1
    mux2 mux_in0 (.sel(c), .d0(d), .d1(1'b1), .y(mux_in[0]));

    // mux_in[1] = 0
    assign mux_in[1] = 1'b0;

    // mux_in[2] = mux2 select c: 0->0, 1->d
    mux2 mux_in2 (.sel(c), .d0(1'b0), .d1(d), .y(mux_in[2]));

    // mux_in[3] = mux2 select c: 0->not_d, 1->1
    mux2 mux_in3 (.sel(c), .d0(not_d), .d1(1'b1), .y(mux_in[3]));
endmodule