module AndGate(input a, input b, output y);
    assign y = a & b;
endmodule

module OrGate4(input a, input b, input c, input d, output y);
    assign y = a | b | c | d;
endmodule

module NotGate(input a, output y);
    assign y = ~a;
endmodule

module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    wire nw;       // inverted w
    wire or_out;   // output of OR gate for Y3
    wire and1_out; // output of AND for Y1
    wire and3_out; // output of AND for Y3

    // Invert input w
    NotGate not1(.a(w), .y(nw));

    // OR gate for states y[1], y[2], y[4], y[5]
    OrGate4 or1(.a(y[1]), .b(y[2]), .c(y[4]), .d(y[5]), .y(or_out));

    // AND for Y1 = y[0] & w
    AndGate and1(.a(y[0]), .b(w), .y(and1_out));

    // AND for Y3 = (y[1] | y[2] | y[4] | y[5]) & ~w
    AndGate and3(.a(or_out), .b(nw), .y(and3_out));

    assign Y1 = and1_out;
    assign Y3 = and3_out;

endmodule