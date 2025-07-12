module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // AND reduction: AND all bits together
    wire and_result = &in;
    
    // OR reduction: OR all bits together
    wire or_result = |in;
    
    // XOR reduction: XOR all bits together
    wire xor_result = ^in;
    
    // Assign outputs
    assign out_and = and_result;
    assign out_or = or_result;
    assign out_xor = xor_result;

endmodule