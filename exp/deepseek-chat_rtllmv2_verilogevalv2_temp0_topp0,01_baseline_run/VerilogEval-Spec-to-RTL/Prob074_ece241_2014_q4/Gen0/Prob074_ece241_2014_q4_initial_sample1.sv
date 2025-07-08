module TopModule (
    input clk,
    input x,
    output z
);

    // Declare flip-flop outputs
    reg xor_ff, and_ff, or_ff;

    // Declare intermediate signals for gate outputs
    wire xor_out, and_out, or_out;

    // XOR gate: input x and its flip-flop's output
    assign xor_out = x ^ xor_ff;

    // AND gate: input x and its flip-flop's complemented output
    assign and_out = x & (~and_ff);

    // OR gate: input x and its flip-flop's complemented output
    assign or_out = x | (~or_ff);

    // Three-input NOR gate for final output
    assign z = ~(xor_ff | and_ff | or_ff);

    // Update flip-flops on positive clock edge
    always @(posedge clk) begin
        xor_ff <= xor_out;
        and_ff <= and_out;
        or_ff <= or_out;
    end

    // Initial reset (simulation only - not synthesizable)
    initial begin
        xor_ff = 1'b0;
        and_ff = 1'b0;
        or_ff = 1'b0;
    end

endmodule