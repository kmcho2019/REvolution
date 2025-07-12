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
    // Implement f0 = c + d
    wire f0;
    or_gate or0(.x(c), .y(d), .out(f0));

    // f1 = 0
    wire f1 = 1'b0;

    // f2 = c & d
    wire f2;
    and_gate and2(.x(c), .y(d), .out(f2));

    // f3 = c + ~d
    wire not_d;
    not_gate inv_d(.in(d), .out(not_d));
    wire f3;
    or_gate or3(.x(c), .y(not_d), .out(f3));

    // mux_in is the 4-bit data input vector to the external 4-to-1 mux
    // Mapping: mux_in[0] = f0 (ab=00)
    //          mux_in[1] = f1 (ab=01)
    //          mux_in[2] = f2 (ab=11)
    //          mux_in[3] = f3 (ab=10)
    assign mux_in = {f3, f2, f1, f0};

endmodule