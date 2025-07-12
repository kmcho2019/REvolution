module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

// Define states
parameter OFF = 1'b0, ON = 1'b1;

// Declare the current state register
reg current_state;
reg next_state;

// Output logic
assign out = current_state;

// Next state logic
always @(*) begin
    case (current_state)
        OFF: next_state = (j) ? ON : OFF;
        ON:  next_state = (k) ? OFF : ON;
        default: next_state = OFF;
    endcase
end

// Sequential logic (update current state on clock edge)
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF; // Reset to OFF on async reset
    end else begin
        current_state <= next_state; // Update current state on clock edge
    end
end

endmodule