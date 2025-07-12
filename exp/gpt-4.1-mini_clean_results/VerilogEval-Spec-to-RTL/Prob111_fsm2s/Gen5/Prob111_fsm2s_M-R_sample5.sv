module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // One-hot state encoding
    reg off_state, on_state;
    reg next_off, next_on;

    // Next state logic (combinational)
    always @(*) begin
        next_off = 1'b0;
        next_on  = 1'b0;
        if (off_state) begin
            if (j)
                next_on = 1'b1;
            else
                next_off = 1'b1;
        end else if (on_state) begin
            if (k)
                next_off = 1'b1;
            else
                next_on = 1'b1;
        end else begin
            // Default to OFF if invalid state
            next_off = 1'b1;
        end
    end

    // State registers with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            off_state <= 1'b1;
            on_state  <= 1'b0;
        end else begin
            off_state <= next_off;
            on_state  <= next_on;
        end
    end

    // Output logic (Moore): output is high if ON state is active
    assign out = on_state;

endmodule