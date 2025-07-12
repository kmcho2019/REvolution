module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // One-hot state encoding signals
    reg state_off;
    reg state_on;

    // Next state signals
    reg next_off;
    reg next_on;

    // Next state logic combinational
    always @(*) begin
        // Default assignments to avoid latches
        next_off = 1'b0;
        next_on  = 1'b0;

        if (state_off) begin
            // From OFF state
            if (j)
                next_on = 1'b1;
            else
                next_off = 1'b1;
        end else if (state_on) begin
            // From ON state
            if (k)
                next_off = 1'b1;
            else
                next_on = 1'b1;
        end else begin
            // Safety default to OFF if invalid state
            next_off = 1'b1;
        end
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state_off <= 1'b1;
            state_on  <= 1'b0;
        end else begin
            state_off <= next_off;
            state_on  <= next_on;
        end
    end

    // Output assignment from ON state bit (Moore output)
    assign out = state_on;

endmodule