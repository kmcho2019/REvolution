module TopModule (
    input clk,
    input x,
    output z
);

    // Combined state register [xor, and, or]
    reg [2:0] state;

    // Synchronous logic with explicit reset
    always @(posedge clk) begin
        state[0] <= x ^ state[0];      // XOR path
        state[1] <= x & ~state[1];    // AND path
        state[2] <= x | ~state[2];    // OR path
    end

    // Output NOR gate (active when all bits are 0)
    assign z = ~(|state);

endmodule