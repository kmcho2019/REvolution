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

// AND gate using mux2
module and_gate (
    input  x,
    input  y,
    output out
);
    // AND(x,y) = mux2(sel=x, in0=0, in1=y)
    mux2 andmux(.sel(x), .in0(1'b0), .in1(y), .out(out));
endmodule

// OR gate using mux2
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
    wire not_c, not_d;
    not_gate inv_c(.in(c), .out(not_c));
    not_gate inv_d(.in(d), .out(not_d));

    // f0 = d + c·¬d
    wire c_and_notd;
    and_gate and0(.x(c), .y(not_d), .out(c_and_notd));
    wire f0;
    or_gate  or0(.x(d), .y(c_and_notd), .out(f0));

    // f1 = 0 (constant zero)
    wire f1 = 1'b0;

    // f2 = c & d
    wire f2;
    and_gate and2(.x(c), .y(d), .out(f2));

    // f3 = c + (~c & ~d)
    wire notc_and_notd;
    and_gate and3(.x(not_c), .y(not_d), .out(notc_and_notd));
    wire f3;
    or_gate  or3(.x(c), .y(notc_and_notd), .out(f3));

    // Assign mux_in with correct bit order per ab:
    // mux_in[0] = ab=00 input = f0
    // mux_in[1] = ab=01 input = f1
    // mux_in[2] = ab=11 input = f2
    // mux_in[3] = ab=10 input = f3
    assign mux_in = {f3, f2, f1, f0};

endmodule