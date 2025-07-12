module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    // One-hot state encoding: two bits representing OFF and ON
    reg state_off, state_on;
    reg next_off, next_on;

    // Next state combinational logic
    always @(*) begin
        // Default assignments to avoid latches
        next_off = 1'b0;
        next_on  = 1'b0;

        // When currently OFF
        if (state_off) begin
            if (j)
                next_on  = 1'b1;
            else
                next_off = 1'b1;
        end
        // When currently ON
        else if (state_on) begin
            if (k)
                next_off = 1'b1;
            else
                next_on  = 1'b1;
        end
        else begin
            // Should not happen, reset to OFF
            next_off = 1'b1;
        end
    end

    // State flip-flops with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state_off <= 1'b1;
            state_on  <= 1'b0;
        end else begin
            state_off <= next_off;
            state_on  <= next_on;
        end
    end

    // Output is 1 when in ON state, else 0
    assign out = state_on;

endmodule