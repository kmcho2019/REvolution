module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    // One-hot state encoding: each bit represents one state
    reg state_A, state_B, state_C, state_D;
    reg next_A, next_B, next_C, next_D;

    // Next state logic combinational
    always @(*) begin
        // Default next state signals to 0
        next_A = 0;
        next_B = 0;
        next_C = 0;
        next_D = 0;

        if (state_A) begin
            if (in == 1'b0) begin
                next_A = 1'b1; // stay in A
            end else begin
                next_B = 1'b1; // go to B
            end
        end else if (state_B) begin
            if (in == 1'b0) begin
                next_C = 1'b1; // go to C
            end else begin
                next_B = 1'b1; // stay in B
            end
        end else if (state_C) begin
            if (in == 1'b0) begin
                next_A = 1'b1; // go to A
            end else begin
                next_D = 1'b1; // go to D
            end
        end else if (state_D) begin
            if (in == 1'b0) begin
                next_C = 1'b1; // go to C
            end else begin
                next_B = 1'b1; // go to B
            end
        end else begin
            // If none active (should not happen), reset to A
            next_A = 1'b1;
        end
    end

    // State flip-flops with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset to state A
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

    // Moore output depends on the current state only
    always @(*) begin
        out = state_D;
    end

endmodule