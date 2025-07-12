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
    // mux_in[0]: ab=00 → output = c & ~d
    mux2 mux0 (.sel(d), .in0(c), .in1(1'b0), .out(mux_in[0]));

    // mux_in[1]: ab=01 → output = ~c & ~d
    mux2 mux1 (.sel(d), .in0(~c), .in1(1'b0), .out(mux_in[1]));

    // mux_in[2]: ab=11 → output = c & d
    mux2 mux2_ (.sel(d), .in0(1'b0), .in1(c), .out(mux_in[2]));

    // mux_in[3]: ab=10 → output = ~d | c
    mux2 mux3 (.sel(d), .in0(1'b1), .in1(c), .out(mux_in[3]));
endmodule