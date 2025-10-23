module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    // One-hot state encoding
    reg state_A, state_B, state_C, state_D;
    reg next_A, next_B, next_C, next_D;

    // Next state combinational logic
    always @(*) begin
        // Default to zero for next state bits
        next_A = 1'b0;
        next_B = 1'b0;
        next_C = 1'b0;
        next_D = 1'b0;

        if (state_A) begin
            if (in == 1'b0)
                next_A = 1'b1;
            else
                next_B = 1'b1;
        end
        else if (state_B) begin
            if (in == 1'b0)
                next_C = 1'b1;
            else
                next_B = 1'b1;
        end
        else if (state_C) begin
            if (in == 1'b0)
                next_A = 1'b1;
            else
                next_D = 1'b1;
        end
        else if (state_D) begin
            if (in == 1'b0)
                next_C = 1'b1;
            else
                next_B = 1'b1;
        end
        else begin
            // In case of invalid state, go to A
            next_A = 1'b1;
        end
    end

    // State flip-flops with asynchronous active-high reset
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

    // Moore output logic (only state D outputs 1)
    always @(*) begin
        out = state_D ? 1'b1 : 1'b0;
    end

endmodule