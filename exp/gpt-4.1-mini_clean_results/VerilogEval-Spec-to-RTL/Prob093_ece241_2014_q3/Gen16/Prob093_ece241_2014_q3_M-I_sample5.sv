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
    // Compute not_d = ~d using mux2
    wire not_d;
    mux2 inv_d(.sel(d), .in0(1'b1), .in1(1'b0), .out(not_d));

    // f0 = c + d = OR(c,d) = mux2(sel=c, in0=d, in1=1)
    wire f0;
    mux2 or0(.sel(c), .in0(d), .in1(1'b1), .out(f0));

    // f1 = 0
    wire f1 = 1'b0;

    // f2 = c & d = AND(c,d) = mux2(sel=c, in0=0, in1=d)
    wire f2;
    mux2 and2(.sel(c), .in0(1'b0), .in1(d), .out(f2));

    // f3 = c + ~d = OR(c, not_d) = mux2(sel=c, in0=not_d, in1=1)
    wire f3;
    mux2 or3(.sel(c), .in0(not_d), .in1(1'b1), .out(f3));

    // Assign mux inputs matching ab mapping:
    // ab=00 -> mux_in[0] = f0
    // ab=01 -> mux_in[1] = f1
    // ab=11 -> mux_in[2] = f2
    // ab=10 -> mux_in[3] = f3
    assign mux_in = {f3, f2, f1, f0};

endmodule