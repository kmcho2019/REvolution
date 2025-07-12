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
reg next_state;    // next state

// Next-state logic using conditional statements
always @(*) begin
    if (current_state == OFF) begin
        next_state = j;
    end else begin
        next_state = ~k;
    end
end

// State register update
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