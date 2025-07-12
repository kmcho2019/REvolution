module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Combinational logic for 4-input AND gate
    assign out_and = &in;

    // Combinational logic for 4-input OR gate
    assign out_or = |in;

    // Combinational logic for 4-input XOR gate
    assign out_xor = ^in;

endmodule