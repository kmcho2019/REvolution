module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    // State bits: A and B one-hot encoded
    reg state_A;
    reg state_B;

    // Next state signals
    reg next_A;
    reg next_B;

    // Next state logic combinational
    always @(*) begin
        // Default assignments to hold current states (important to avoid latches)
        next_A = state_A;
        next_B = state_B;

        if (state_B) begin
            if (in == 1'b0) begin
                next_A = 1'b1;
                next_B = 1'b0;
            end else begin
                next_A = 1'b0;
                next_B = 1'b1;
            end
        end else if (state_A) begin
            if (in == 1'b0) begin
                next_A = 1'b0;
                next_B = 1'b1;
            end else begin
                next_A = 1'b1;
                next_B = 1'b0;
            end
        end else begin
            // Safety fallback: if neither state is set, reset to B
            next_A = 1'b0;
            next_B = 1'b1;
        end
    end

    // State register update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b0;
            state_B <= 1'b1;  // Reset to state B
        end else begin
            state_A <= next_A;
            state_B <= next_B;
        end
    end

    // Output is 1 when in state B (one-hot bit set), else 0
    assign out = state_B;

endmodule