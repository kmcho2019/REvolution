module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // One-hot state registers
    reg state_off, state_on;

    // Next state signals (combinational)
    wire next_off, next_on;

    // Next state logic
    assign next_off = (reset) ? 1'b1 : (state_off & ~j) | (state_on & k);
    assign next_on  = (reset) ? 1'b0 : (state_off & j) | (state_on & ~k);

    // Sequential update of one-hot state registers
    always @(posedge clk) begin
        if (reset) begin
            state_off <= 1'b1;
            state_on  <= 1'b0;
        end else begin
            state_off <= next_off;
            state_on  <= next_on;
        end
    end

    // Output is high when ON state is active (Moore output)
    assign out = state_on;

endmodule