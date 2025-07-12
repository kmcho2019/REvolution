// Define the states as enumerations
parameter OFF = 1'b0;
parameter ON  = 1'b1;

// Define the lookup table for next-state and output values
parameter [1:0] LUT [2] = '{OFF: {1'b0, OFF}, ON: {1'b1, ON}};

module TopModule(
    input  clk,    // clock
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg current_state; // current state

// State register update with LUT-based next-state logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else begin
        case (current_state)
            OFF: current_state <= j? ON : OFF;
            ON:  current_state <= k? OFF : ON;
            default: current_state <= OFF;
        endcase
    end
end

// Output logic directly from state
assign out = (current_state == ON)? 1'b1 : 1'b0;

endmodule