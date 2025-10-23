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
wire next_state;   // next state

// Combinational logic to determine next state
// This logic implements the state transitions based on the current state and inputs
assign next_state = (current_state == OFF && j) || (current_state == ON && !k);

// Sequential logic to update current state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

// Output logic directly from state
assign out = current_state;

endmodule