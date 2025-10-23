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
    mux2 not_c_mux(.sel(c), .in0(1'b1), .in1(1'b0), .out(not_c));

    // NOT d = mux2(d, 1, 0)
    wire not_d;
    mux2 not_d_mux(.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d));

    // AND(x,y) = mux2(x, 0, y)
    // Create AND signals needed:

    // and_not_c_not_d = AND(not_c, not_d)
    wire and_not_c_not_d;
    mux2 and_not_c_not_d_mux(.sel(not_c), .in0(1'b0), .in1(not_d), .out(and_not_c_not_d));

    // and_c_d = AND(c, d)
    wire and_c_d;
    mux2 and_c_d_mux(.sel(c), .in0(1'b0), .in1(d), .out(and_c_d));

    // and_d_not_c = AND(d, not_c)
    wire and_d_not_c;
    mux2 and_d_not_c_mux(.sel(d), .in0(1'b0), .in1(not_c), .out(and_d_not_c));

    // Implement OR(x,y) = NOT(AND(NOT x, NOT y))
    // So OR(c,d) = NOT(AND(not_c, not_d)) = mux2(and_not_c_not_d, 1, 0)
    wire or_c_d;
    mux2 or_c_d_mux(.sel(and_not_c_not_d), .in0(1'b1), .in1(1'b0), .out(or_c_d));

    // OR(not_d, c) = NOT(AND(d, not_c)) = mux2(and_d_not_c, 1, 0)
    wire or_not_d_c;
    mux2 or_not_d_c_mux(.sel(and_d_not_c), .in0(1'b1), .in1(1'b0), .out(or_not_d_c));

    // Assign mux_in according to ab:
    // ab=00 -> mux_in[0] = function for K-map column 00
    // From K-map (ab=00), column c,d mapping is: (cd=00:0, 01:1, 11:1, 10:1)
    // This corresponds exactly to OR(c,d) = mux_in[0]
    assign mux_in[0] = or_c_d;

    // ab=01 -> mux_in[1] always 0 per K-map
    assign mux_in[1] = 1'b0;

    // ab=11 -> mux_in[2] = AND(c,d)
    assign mux_in[2] = and_c_d;

    // ab=10 -> mux_in[3] = OR(not d, c)
    assign mux_in[3] = or_not_d_c;

endmodule