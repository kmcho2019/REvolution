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
reg reset_sync;    // synchronized reset

// Reset synchronization
always @(posedge clk or posedge areset) begin
    if (areset) begin
        reset_sync <= 1'b1;
    end else begin
        reset_sync <= 1'b0;
    end
end

// Simplified next state logic with one-hot encoding
always @(posedge clk or posedge reset_sync) begin
    if (reset_sync) begin
        current_state <= OFF;
    end else begin
        current_state <= (current_state == OFF) ? (j ? ON : OFF) : (k ? ON : OFF);
    end
end

// Output logic directly from state
assign out = current_state;

endmodule