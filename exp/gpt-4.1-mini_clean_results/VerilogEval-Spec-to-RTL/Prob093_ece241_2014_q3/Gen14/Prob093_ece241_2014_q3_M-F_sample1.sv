module mux2 (
    input  sel,
    input  in0,
    input  in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

// NOT gate implemented using mux2: NOT x = mux2(sel=x, in0=1, in1=0)
module not_gate (
    input  in,
    output out
);
    mux2 inv(.sel(in), .in0(1'b1), .in1(1'b0), .out(out));
endmodule

module TopModule (
    input  a,    // 1-bit selector input for 4-to-1 mux (MSB)
    input  b,    // 1-bit selector input for 4-to-1 mux (LSB)
    input  c,
    input  d,
    output [3:0] mux_in
);
    // Generate NOT signals for c and d
    wire not_c, not_d;

    not_gate inv_c(.in(c), .out(not_c));
    not_gate inv_d(.in(d), .out(not_d));

    // f0 = mux2(sel=c, in0=d, in1=1)
    wire f0;
    mux2 f0_mux(.sel(c), .in0(d), .in1(1'b1), .out(f0));

    // f1 = 0
    wire f1 = 1'b0;

    // f2 = mux2(sel=c, in0=0, in1=d)
    wire f2;
    mux2 f2_mux(.sel(c), .in0(1'b0), .in1(d), .out(f2));

    // f3 = mux2(sel=c, in0=~d, in1=1)
    // ~d is not_d
    wire f3;
    mux2 f3_mux(.sel(c), .in0(not_d), .in1(1'b1), .out(f3));

    // Assign mux_in with {f3, f2, f1, f0} mapping to ab=10,11,01,00
    // So mux_in[3] corresponds to ab=10
    // mux_in[2] corresponds to ab=11
    // mux_in[1] corresponds to ab=01
    // mux_in[0] corresponds to ab=00

    assign mux_in = {f3, f2, f1, f0};

    // Inputs a,b are used as selectors outside this module for the 4-to-1 mux,
    // so they are declared here but not used internally.
endmodule