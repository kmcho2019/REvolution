module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // One-hot encoding of states
    // Only one bit set high for the current state
    reg state_A, state_B, state_C, state_D;
    reg next_A, next_B, next_C, next_D;

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
            state_C <= 1'b0;
            state_D <= 1'b0;
        end else begin
            state_A <= next_A;
            state_B <= next_B;
            state_C <= next_C;
            state_D <= next_D;
        end
    end

    // Combinational next state logic based on current one-hot state and input
    always @(*) begin
        // Default all zeros to prevent latches
        next_A = 1'b0;
        next_B = 1'b0;
        next_C = 1'b0;
        next_D = 1'b0;

        // State A: in=0->A, in=1->B
        if (state_A) begin
            if (in) next_B = 1'b1;
            else    next_A = 1'b1;
        end
        // State B: in=0->C, in=1->B
        else if (state_B) begin
            if (in) next_B = 1'b1;
            else    next_C = 1'b1;
        end
        // State C: in=0->A, in=1->D
        else if (state_C) begin
            if (in) next_D = 1'b1;
            else    next_A = 1'b1;
        end
        // State D: in=0->C, in=1->B
        else if (state_D) begin
            if (in) next_B = 1'b1;
            else    next_C = 1'b1;
        end
        else begin
            // If no state is active (should not happen), go to A
            next_A = 1'b1;
        end
    end

    // Output logic depends on current state (Moore FSM)
    assign out = state_D;

endmodule