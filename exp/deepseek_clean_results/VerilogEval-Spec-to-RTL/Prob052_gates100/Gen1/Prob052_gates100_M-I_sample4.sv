module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    wire [99:0] in_wire = in;  // Explicit wire declaration for clarity
    
    assign out_and = &in_wire;  // 100-input AND
    assign out_or  = |in_wire;  // 100-input OR
    assign out_xor = ^in_wire;  // 100-input XOR

endmodule