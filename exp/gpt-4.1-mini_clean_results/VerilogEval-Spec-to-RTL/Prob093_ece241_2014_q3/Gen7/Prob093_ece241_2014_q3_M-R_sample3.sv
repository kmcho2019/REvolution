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
    // NOT c: inv_c = ~c = mux2(c, 1, 0)
    wire inv_c;
    mux2 inv_c_mux (.sel(c), .in0(1'b1), .in1(1'b0), .out(inv_c));

    // NOT d: inv_d = ~d = mux2(d, 1, 0)
    wire inv_d;
    mux2 inv_d_mux (.sel(d), .in0(1'b1), .in1(1'b0), .out(inv_d));

    // AND(inv_c, inv_d) = inv_c & inv_d = mux2(inv_c, 0, inv_d)
    wire and_inv_c_inv_d;
    mux2 and_inv_mux (.sel(inv_c), .in0(1'b0), .in1(inv_d), .out(and_inv_c_inv_d));

    // NOT of AND(inv_c, inv_d) = mux2(and_inv_c_inv_d, 1, 0)
    wire not_and_inv_c_inv_d;
    mux2 not_and_inv_mux (.sel(and_inv_c_inv_d), .in0(1'b1), .in1(1'b0), .out(not_and_inv_c_inv_d));
    // mux_in[0] = c + d = NOT(NOT c & NOT d)
    assign mux_in[0] = not_and_inv_c_inv_d;

    // mux_in[1] = 0 (from K-map column for ab=01)
    assign mux_in[1] = 1'b0;

    // mux_in[2] = c & d = mux2(c, 0, d)
    wire and_c_d;
    mux2 and_c_d_mux (.sel(c), .in0(1'b0), .in1(d), .out(and_c_d));
    assign mux_in[2] = and_c_d;

    // mux_in[3] = mux2(d, 1, c)
    wire mux3_out;
    mux2 mux3_mux (.sel(d), .in0(1'b1), .in1(c), .out(mux3_out));
    assign mux_in[3] = mux3_out;

endmodule