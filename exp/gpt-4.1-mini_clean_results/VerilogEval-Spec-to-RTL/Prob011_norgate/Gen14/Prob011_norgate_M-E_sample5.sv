module NOTGate(
    input in,
    output out
);
    assign out = ~in;
endmodule

module ANDGate(
    input in1,
    input in2,
    output out
);
    assign out = in1 & in2;
endmodule

module TopModule (
    input  a,
    input  b,
    output out
);

    wire not_a, not_b;

    // Instantiate NOT gates for each input
    NOTGate u1(.in(a), .out(not_a));
    NOTGate u2(.in(b), .out(not_b));

    // Instantiate AND gate to produce NOR result
    ANDGate u3(.in1(not_a), .in2(not_b), .out(out));

endmodule