module NotGate (
    input  wire a,
    output wire y
);
    assign y = ~a;
endmodule

module AndGate (
    input  wire a,
    input  wire b,
    output wire y
);
    assign y = a & b;
endmodule

module TopModule (
    input  wire in1,
    input  wire in2,
    output wire out
);
    wire in2_inv;

    NotGate inv1 (
        .a(in2),
        .y(in2_inv)
    );

    AndGate and1 (
        .a(in1),
        .b(in2_inv),
        .y(out)
    );

endmodule