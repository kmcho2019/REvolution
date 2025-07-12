// Define the states as parameters
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

// Direct next state logic without case statement
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else if (current_state == OFF) begin
        current_state <= j ? ON : OFF;
    end else begin // current_state == ON
        current_state <= k ? OFF : ON;
    end
end

// Output logic directly from state
assign out = current_state;

endmodule