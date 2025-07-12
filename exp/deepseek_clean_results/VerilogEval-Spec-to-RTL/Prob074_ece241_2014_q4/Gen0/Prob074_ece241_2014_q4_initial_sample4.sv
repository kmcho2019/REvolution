module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg xor_ff, and_ff, or_ff;

    // Gate outputs before flip-flops
    wire xor_out, and_out, or_out;

    // XOR path: x XOR flip-flop output
    assign xor_out = x ^ xor_ff;

    // AND path: x AND (NOT flip-flop output)
    assign and_out = x & (~and_ff);

    // OR path: x OR (NOT flip-flop output)
    assign or_out = x | (~or_ff);

    // Update flip-flops on positive clock edge
    always @(posedge clk) begin
        xor_ff <= xor_out;
        and_ff <= and_out;
        or_ff <= or_out;
    end

    // Final three-input NOR gate
    assign z = ~(xor_ff | and_ff | or_ff);

endmodule