module mux2 (
    input  sel,
    input  in0,
    input  in1,
    output out
);
    assign out = sel ? in1 : in0;
endmodule

// NOT gate using mux2: NOT(x) = mux2(sel = x, in0=1, in1=0)
module not_gate (
    input  in,
    output out
);
    mux2 u_not (.sel(in), .in0(1'b1), .in1(1'b0), .out(out));
endmodule

// AND gate using mux2: AND(x,y) = mux2(sel = x, in0=0, in1=y)
module and_gate (
    input  x,
    input  y,
    output out
);
    mux2 u_and (.sel(x), .in0(1'b0), .in1(y), .out(out));
endmodule

// OR gate using mux2: OR(x,y) = mux2(sel = x, in0 = y, in1 = 1)
module or_gate (
    input  x,
    input  y,
    output out
);
    mux2 u_or (.sel(x), .in0(y), .in1(1'b1), .out(out));
endmodule

module TopModule (
    input  c,
    input  d,
    output [3:0] mux_in
);
    // Invert inputs
    wire not_c, not_d;
    not_gate notc(.in(c), .out(not_c));
    not_gate notd(.in(d), .out(not_d));

    // For ab=00 (mux_in[0]): Column 00 of K-map: cd=00:0, 01:1, 11:1, 10:1
    // Expression from column: f00 = d + (c & ~d)
    wire c_and_notd;
    and_gate and1(.x(c), .y(not_d), .out(c_and_notd));
    wire f00;
    or_gate or1(.x(d), .y(c_and_notd), .out(f00));

    // For ab=01 (mux_in[1]): Column 01: all zeroes (0,0,0,0)
    wire f01 = 1'b0;

    // For ab=11 (mux_in[2]): Column 11: cd=00:0,01:0,11:1,10:0
    // Expression: c & d
    wire f11;
    and_gate and2(.x(c), .y(d), .out(f11));

    // For ab=10 (mux_in[3]): Column 10: cd=00:1, 01:0, 11:1, 10:1
    // Expression: c + (~c & ~d)
    wire notc_and_notd;
    and_gate and3(.x(not_c), .y(not_d), .out(notc_and_notd));
    wire f10;
    or_gate or2(.x(c), .y(notc_and_notd), .out(f10));

    // Assign mux_in bits as per selector order:
    // mux_in[0] = f00 (ab=00)
    // mux_in[1] = f01 (ab=01)
    // mux_in[2] = f11 (ab=11)
    // mux_in[3] = f10 (ab=10)
    assign mux_in = {f10, f11, f01, f00};

endmodule