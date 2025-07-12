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

// State register update with simplified next-state logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else if ((current_state == OFF && j) || (current_state == ON && ~k)) begin
        current_state <= current_state;
    end else begin
        current_state <= ~current_state;
    end
end

// Output logic directly from state
assign out = current_state;

endmodule