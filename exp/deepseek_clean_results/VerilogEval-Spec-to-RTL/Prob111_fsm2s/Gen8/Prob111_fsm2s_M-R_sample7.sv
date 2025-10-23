module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // One-hot state representation
    wire state_off, state_on;
    reg state_off_reg, state_on_reg;

    // Next state logic (continuous assignments)
    assign state_off = (~state_on_reg & ~j) | (state_on_reg & k);
    assign state_on = (~state_on_reg & j) | (state_on_reg & ~k);

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state_off_reg <= 1'b1;
            state_on_reg <= 1'b0;
        end else begin
            state_off_reg <= state_off;
            state_on_reg <= state_on;
        end
    end

    // Output assignment
    assign out = state_on_reg;

endmodule