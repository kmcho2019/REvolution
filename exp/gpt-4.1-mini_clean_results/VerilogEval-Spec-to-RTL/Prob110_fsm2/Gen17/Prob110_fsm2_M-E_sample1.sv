module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    // One-hot state encoding
    // state_off = 1 if OFF state
    // state_on  = 1 if ON state
    reg state_off, state_on;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_off <= 1'b1;  // reset to OFF
            state_on  <= 1'b0;
        end else begin
            // Next state logic
            state_off <= (state_off & ~j) | (state_on & k);
            state_on  <= (state_off & j)  | (state_on & ~k);
        end
    end

    // Output logic: out = 1 when ON state
    assign out = state_on;

endmodule