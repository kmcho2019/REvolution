module TopModule (
    input clk,
    input x,
    output z
);

    // Three flip-flops for each operation
    reg xor_ff, and_ff, or_ff;

    // XOR path: x XOR with its own output
    wire xor_in = x ^ xor_ff;

    // AND path: x AND with its complemented output
    wire and_in = x & ~and_ff;

    // OR path: x OR with its complemented output
    wire or_in = x | ~or_ff;

    // Update all flip-flops on clock edge
    always @(posedge clk) begin
        xor_ff <= xor_in;
        and_ff <= and_in;
        or_ff <= or_in;
    end

    // Output is NOR of all flip-flop outputs
    assign z = ~(xor_ff | and_ff | or_ff);

    // Initialization (optional in Verilog for synthesis)
    initial begin
        xor_ff = 1'b0;
        and_ff = 1'b0;
        or_ff = 1'b0;
    end

endmodule