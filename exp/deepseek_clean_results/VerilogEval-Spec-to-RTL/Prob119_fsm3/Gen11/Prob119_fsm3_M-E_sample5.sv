module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // One-hot state encoding
    reg [3:0] state;  // bits represent states A, B, C, D respectively
    
    // State definitions (not strictly needed but improves readability)
    wire state_A = state[0];
    wire state_B = state[1];
    wire state_C = state[2];
    wire state_D = state[3];
    
    // Next state logic (parallel continuous assignments)
    wire [3:0] next_state;
    assign next_state[0] = (~in & state_A) | (~in & state_C);  // A stays or C->A
    assign next_state[1] = (in & state_A) | (in & state_B) | (in & state_D);  // A->B, B stays, D->B
    assign next_state[2] = (~in & state_B) | (~in & state_D);  // B->C, D->C
    assign next_state[3] = (in & state_C);  // C->D
    
    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 4'b0001;  // Reset to state A (one-hot)
        end else begin
            state <= next_state;
        end
    end
    
    // Output is simply the D state bit
    assign out = state_D;

endmodule