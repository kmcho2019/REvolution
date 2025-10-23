module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    // One-hot state encoding
    reg state_off, state_on;
    reg next_off, next_on;

    // Next-state combinational logic
    always @(*) begin
        // Default no change
        next_off = state_off;
        next_on  = state_on;
        if (state_off) begin
            if (j)
                begin next_on = 1'b1; next_off = 1'b0; end
            else
                begin next_off = 1'b1; next_on = 1'b0; end
        end else if (state_on) begin
            if (k)
                begin next_off = 1'b1; next_on = 1'b0; end
            else
                begin next_on = 1'b1; next_off = 1'b0; end
        end else begin
            // Safety fallback: stay in OFF if somehow no state active
            next_off = 1'b1; 
            next_on  = 1'b0;
        end
    end

    // State registers with synchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_off <= 1'b1; // OFF state active after reset
            state_on  <= 1'b0;
        end else begin
            state_off <= next_off;
            state_on  <= next_on;
        end
    end

    // Output from ON state (Moore output)
    assign out = state_on;

endmodule