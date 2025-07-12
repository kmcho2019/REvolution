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
    // Direct primitive nor gate instantiation for optimal PPA
    nor u_nor(out, a, b);
endmodule