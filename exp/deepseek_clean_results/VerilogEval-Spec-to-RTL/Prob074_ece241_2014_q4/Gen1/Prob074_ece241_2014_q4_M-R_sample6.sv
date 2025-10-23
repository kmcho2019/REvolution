module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg q_xor, q_and, q_or;

    // Combinational logic for D inputs
    wire d_xor, d_and, d_or;

    // XOR path: x XOR q_xor (feedback)
    assign d_xor = x ^ q_xor;

    // AND path: x AND ~q_and (complemented feedback)
    assign d_and = x & ~q_and;

    // OR path: x OR ~q_or (complemented feedback)
    assign d_or = x | ~q_or;

    // D flip-flop for XOR path
    always @(posedge clk) begin
        q_xor <= d_xor;
    end

    // D flip-flop for AND path
    always @(posedge clk) begin
        q_and <= d_and;
    end

    // D flip-flop for OR path
    always @(posedge clk) begin
        q_or <= d_or;
    end

    // Three-input NOR gate for output z
    assign z = ~(q_xor | q_and | q_or);

    // Initialization (simulation only - for synthesis would need proper reset)
    initial begin
        q_xor = 0;
        q_and = 0;
        q_or = 0;
    end

endmodule