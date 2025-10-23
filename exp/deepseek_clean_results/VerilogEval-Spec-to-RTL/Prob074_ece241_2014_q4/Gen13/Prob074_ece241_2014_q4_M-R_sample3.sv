module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg xor_ff, and_ff, or_ff;

    // Continuous assignments for gate inputs
    wire xor_gate = x ^ xor_ff;
    wire and_gate = x & ~and_ff;
    wire or_gate = x | ~or_ff;

    // Sequential logic (flip-flops)
    always @(posedge clk) begin
        xor_ff <= xor_gate;
        and_ff <= and_gate;
        or_ff <= or_gate;
    end

    // Output NOR gate
    assign z = ~(xor_ff | and_ff | or_ff);

    // Initialization (optional in most simulators)
    initial begin
        xor_ff = 0;
        and_ff = 0;
        or_ff = 0;
    end

endmodule