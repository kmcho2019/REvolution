module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // One-hot encoded state registers
    reg [3:0] state;
    parameter A = 4'b0001,
              B = 4'b0010,
              C = 4'b0100,
              D = 4'b1000;

    // Asynchronous reset and state transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            // Parallel state transition logic
            state[0] <= (state == A && ~in) || (state == C && ~in);  // Next A
            state[1] <= (state == A && in) || (state == B && in) || (state == D && in);  // Next B
            state[2] <= (state == B && ~in) || (state == C && in) || (state == D && ~in);  // Next C
            state[3] <= (state == C && in);  // Next D
        end
    end

    // Output logic - only active in state D
    assign out = state[3];

endmodule