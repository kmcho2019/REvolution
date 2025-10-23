module mux2 (
    input  sel,
    input  in0,
    input  in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

// Helper modules to implement NOT, AND, OR using mux2
module not_gate (
    input  in,
    output out
);
    // NOT(in) = mux2(sel=in, in0=1, in1=0)
    mux2 inv(.sel(in), .in0(1'b1), .in1(1'b0), .out(out));
endmodule

module and_gate (
    input  x,
    input  y,
    output out
);
    // AND(x,y) = mux2(sel=x, in0=0, in1=y)
    mux2 andmux(.sel(x), .in0(1'b0), .in1(y), .out(out));
endmodule

module or_gate (
    input  x,
    input  y,
    output out
);
    // OR(x,y) = mux2(sel=x, in0=y, in1=1)
    mux2 ormux(.sel(x), .in0(y), .in1(1'b1), .out(out));
endmodule

module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // Wires for inverted signals
    wire not_c, not_d;
    not_gate notc(.in(c), .out(not_c));
    not_gate notd(.in(d), .out(not_d));

    // f00 = d + c(~d)
    // Step1: c & ~d
    wire c_and_notd;
    and_gate and1(.x(c), .y(not_d), .out(c_and_notd));
    // Step2: d + c_and_notd
    wire f00;
    or_gate or1(.x(d), .y(c_and_notd), .out(f00));

    // f01 = 0 (constant zero)
    wire f01 = 1'b0;

    // f11 = c & d
    wire f11;
    and_gate and2(.x(c), .y(d), .out(f11));

    // f10 = c + (~c & ~d)
    wire notc_and_notd;
    and_gate and3(.x(not_c), .y(not_d), .out(notc_and_notd));
    wire f10;
    or_gate or2(.x(c), .y(notc_and_notd), .out(f10));

    // Assign mux_in with correct bit order:
    // mux_in[0] = f00 for ab=00
    // mux_in[1] = f01 for ab=01
    // mux_in[2] = f11 for ab=11
    // mux_in[3] = f10 for ab=10
    assign mux_in = {f10, f11, f01, f00};

endmodule