module TopModule (
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // One-hot state flip-flops
    reg state_off;
    reg state_on;

    // Next state logic signals
    wire next_off;
    wire next_on;

    // Next state combinational logic
    assign next_off = (state_off & ~j) | (state_on & k);
    assign next_on  = (state_off & j)  | (state_on & ~k);

    // State flip-flops with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            state_off <= 1'b1;  // Reset to OFF state
            state_on  <= 1'b0;
        end else begin
            state_off <= next_off;
            state_on  <= next_on;
        end
    end

    // Output: ON state represents out=1; OFF state out=0
    assign out = state_on;

endmodule