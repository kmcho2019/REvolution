module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

// Define state parameters
parameter OFF = 1'b0;
parameter ON  = 1'b1;

reg state;  // Current state
reg next_state;  // Next state

// Combinational state transition logic
always @(*) begin
    case (state)
        OFF: next_state = j ? ON : OFF;
        ON:  next_state = k ? OFF : ON;
        default: next_state = OFF;
    endcase
end

// Sequential state register with async reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= OFF;  // Async reset to OFF
    end else begin
        state <= next_state;
    end
end

// Output assignment (Moore style)
assign out = state;

endmodule