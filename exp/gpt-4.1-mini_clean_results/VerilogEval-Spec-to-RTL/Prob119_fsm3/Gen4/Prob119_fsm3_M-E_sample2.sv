module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    // One-hot state signals
    reg state_A, state_B, state_C, state_D;
    reg next_state_A, next_state_B, next_state_C, next_state_D;

    // Next state combinational logic
    always @(*) begin
        // Default next states to 0
        next_state_A = 1'b0;
        next_state_B = 1'b0;
        next_state_C = 1'b0;
        next_state_D = 1'b0;

        if (state_A) begin
            if (in == 1'b0)
                next_state_A = 1'b1;
            else
                next_state_B = 1'b1;
        end else if (state_B) begin
            if (in == 1'b0)
                next_state_C = 1'b1;
            else
                next_state_B = 1'b1;
        end else if (state_C) begin
            if (in == 1'b0)
                next_state_A = 1'b1;
            else
                next_state_D = 1'b1;
        end else if (state_D) begin
            if (in == 1'b0)
                next_state_C = 1'b1;
            else
                next_state_B = 1'b1;
        end else begin
            // If no state is active (shouldn't happen), go to A
            next_state_A = 1'b1;
        end
    end

    // State registers with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;
            state_B <= 1'b0;
            state_C <= 1'b0;
            state_D <= 1'b0;
        end else begin
            state_A <= next_state_A;
            state_B <= next_state_B;
            state_C <= next_state_C;
            state_D <= next_state_D;
        end
    end

    // Moore output logic: output=1 only in state D
    always @(*) begin
        out = state_D;
    end

endmodule