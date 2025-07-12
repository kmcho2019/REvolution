// Define the states as enumerations
parameter OFF = 1'b0;
parameter ON  = 1'b1;

module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg current_state; // current state

// State register update with simplified next-state logic and clock gating
reg clk_enable;
assign clk_enable = ~areset; // Clock enable is active when reset is not asserted

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else if (clk_enable) begin
        case (current_state)
            OFF: current_state <= j ? ON : OFF;
            ON:  current_state <= k ? OFF : ON;
            default: current_state <= OFF;
        endcase
    end
end

// Output logic directly from state
assign out = current_state;

endmodule