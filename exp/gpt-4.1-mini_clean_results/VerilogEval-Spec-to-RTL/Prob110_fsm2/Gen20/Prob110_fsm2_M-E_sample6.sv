module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    // One-hot state encoding: two flip-flops
    reg state_off, state_on;

    // Next state combinational signals
    wire next_off, next_on;

    // Next state logic
    assign next_off = (state_off & ~j) | (state_on & k);
    assign next_on  = (state_off & j) | (state_on & ~k);

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_off <= 1'b1;  // Reset to OFF state
            state_on  <= 1'b0;
        end else begin
            state_off <= next_off;
            state_on  <= next_on;
        end
    end

    // Output is high if ON state flip-flop is set (Moore output)
    assign out = state_on;

endmodule