module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // One-hot state encoding: [A, B, C, D]
    reg [3:0] state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 4'b0001; // Reset to state A
        end else begin
            // Parallel state transition logic
            state[0] <= (~in & state[0]) | (~in & state[2]); // A stays or C->A
            state[1] <= (in & state[0]) | (in & state[1]) | (in & state[3]); // A->B or B stays or D->B
            state[2] <= (~in & state[1]) | (~in & state[3]); // B->C or D->C
            state[3] <= (in & state[2]); // C->D
        end
    end

    assign out = state[3]; // Output is state D bit

endmodule