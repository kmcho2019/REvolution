module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // One-hot state encoding: each state has its own flip-flop
    reg state_A, state_B, state_C, state_D;
    reg next_A, next_B, next_C, next_D;

    // State register with asynchronous reset
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

    // Next state combinational logic derived from current state and input
    always @(*) begin
        // Default all next states to 0 to avoid latches
        next_A = 1'b0;
        next_B = 1'b0;
        next_C = 1'b0;
        next_D = 1'b0;

        if (state_A) begin
            // A: in=0->A, in=1->B
            if (in)
                next_B = 1'b1;
            else
                next_A = 1'b1;
        end else if (state_B) begin
            // B: in=0->C, in=1->B
            if (in)
                next_B = 1'b1;
            else
                next_C = 1'b1;
        end else if (state_C) begin
            // C: in=0->A, in=1->D
            if (in)
                next_D = 1'b1;
            else
                next_A = 1'b1;
        end else if (state_D) begin
            // D: in=0->C, in=1->B
            if (in)
                next_B = 1'b1;
            else
                next_C = 1'b1;
        end else begin
            // If no valid state (should not happen), reset to A
            next_A = 1'b1;
        end
    end

    // Output logic: 1 only in state D (Moore machine)
    assign out = state_D;

endmodule