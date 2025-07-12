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

// State register update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else begin
        // Direct calculation of next state based on current state and inputs
        current_state <= (current_state == OFF) ? (j ? ON : OFF) : (k ? OFF : ON);
    end
end

// Output logic directly from state
assign out = current_state;

endmodule