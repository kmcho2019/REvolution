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
    // Direct NOR gate implementation for minimal area, power, and delay
    assign out = ~(a | b);
endmodule