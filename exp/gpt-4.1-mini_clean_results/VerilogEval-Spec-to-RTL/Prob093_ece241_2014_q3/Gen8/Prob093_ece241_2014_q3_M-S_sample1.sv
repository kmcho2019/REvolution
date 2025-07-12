module mux2 (
    input  sel,
    input  in0,
    input  in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // NOT c = mux2(c, 1, 0)
    wire not_c;
    mux2 not_c_mux (.sel(c), .in0(1'b1), .in1(1'b0), .out(not_c));

    // NOT d = mux2(d, 1, 0)
    wire not_d;
    mux2 not_d_mux (.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d));

    // AND(x,y) = mux2(x, 0, y)

    // OR(x,y) = NOT(AND(NOT x, NOT y))
    // Implement mux_in[0] = OR(c,d) = NOT(AND(NOT c, NOT d))
    wire and_not_c_not_d;
    mux2 and_not_c_not_d_mux (.sel(not_c), .in0(1'b0), .in1(not_d), .out(and_not_c_not_d));
    mux2 or_c_d_mux (.sel(and_not_c_not_d), .in0(1'b1), .in1(1'b0), .out(mux_in[0]));

    // mux_in[1] = 0 (from K-map)
    assign mux_in[1] = 1'b0;

    // mux_in[2] = AND(c,d)
    mux2 and_c_d_mux (.sel(c), .in0(1'b0), .in1(d), .out(mux_in[2]));

    // mux_in[3] = OR(not d, c) = NOT(AND(d, NOT c))
    wire and_d_not_c;
    mux2 and_d_not_c_mux (.sel(d), .in0(1'b0), .in1(not_c), .out(and_d_not_c));
    mux2 or_not_d_c_mux (.sel(and_d_not_c), .in0(1'b1), .in1(1'b0), .out(mux_in[3]));

endmodule