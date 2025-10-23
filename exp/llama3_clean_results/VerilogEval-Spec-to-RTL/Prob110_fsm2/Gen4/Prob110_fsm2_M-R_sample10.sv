module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

// Define states
parameter OFF = 1'b0;
parameter ON  = 1'b1;

// Current state register
reg current_state;

// Next state logic
reg next_state;
assign next_state = (current_state == OFF) ? (j ? ON : OFF) : (k ? OFF : ON);

// Output logic
assign out = current_state;

// State register update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
    end else begin
        current_state <= next_state;
    end
end

endmodule