module mux2 (
    input  sel,
    input  in0,
    input  in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

// NOT gate using mux2
module not_gate (
    input  in,
    output out
);
    // NOT(in) = mux2(sel=in, in0=1, in1=0)
    mux2 inv(.sel(in), .in0(1'b1), .in1(1'b0), .out(out));
endmodule

module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);

    wire not_c;

    // NOT c
    not_gate inv_c(.in(c), .out(not_c));

    // f0 = mux2(sel=c, in0=d, in1=1)
    wire f0;
    mux2 f0_mux(.sel(c), .in0(d), .in1(1'b1), .out(f0));

    // f1 = 0
    wire f1 = 1'b0;

    // f2 = mux2(sel=c, in0=0, in1=d)
    wire f2;
    mux2 f2_mux(.sel(c), .in0(1'b0), .in1(d), .out(f2));

    // f3 = mux2(sel=c, in0=~d, in1=1)
    // Implement ~d as not_gate
    wire not_d;
    not_gate inv_d(.in(d), .out(not_d));

    wire f3;
    mux2 f3_mux(.sel(c), .in0(not_d), .in1(1'b1), .out(f3));

    assign mux_in = {f3, f2, f1, f0};

endmodule