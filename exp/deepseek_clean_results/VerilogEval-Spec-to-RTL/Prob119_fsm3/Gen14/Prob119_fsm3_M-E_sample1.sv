module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // One-hot state encoding
    parameter A = 4'b0001;
    parameter B = 4'b0010;
    parameter C = 4'b0100;
    parameter D = 4'b1000;

    reg [3:0] state;

    // Parallel state transition logic
    wire [3:0] next_state;
    assign next_state[0] = (state == A && ~in) || (state == C && ~in);  // A
    assign next_state[1] = (state == A && in) || (state == B && in) || (state == D && in);  // B
    assign next_state[2] = (state == B && ~in) || (state == C && in) || (state == D && ~in);  // C
    assign next_state[3] = (state == C && in);  // D

    // State update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) state <= A;
        else state <= next_state;
    end

    // Output logic (Moore)
    assign out = (state == D);

endmodule