module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define the states of the FSM
reg [1:0] current_state;
reg [1:0] next_state;

// State table
always @(*) begin
    case(current_state)
        2'b00: // State A
            if (~r[2] && ~r[1] && ~r[0])
                next_state = 2'b00; // Stay in state A if no requests
            else if (r[0])
                next_state = 2'b01; // Go to state B if device 0 requests
            else if (r[1])
                next_state = 2'b10; // Go to state C if device 1 requests
            else
                next_state = 2'b11; // Go to state D if device 2 requests
        2'b01: // State B
            if (r[0])
                next_state = 2'b01; // Stay in state B if device 0 still requests
            else
                next_state = 2'b00; // Go back to state A if device 0 no longer requests
        2'b10: // State C
            if (r[1])
                next_state = 2'b10; // Stay in state C if device 1 still requests
            else
                next_state = 2'b00; // Go back to state A if device 1 no longer requests
        2'b11: // State D
            if (r[2])
                next_state = 2'b11; // Stay in state D if device 2 still requests
            else
                next_state = 2'b00; // Go back to state A if device 2 no longer requests
        default: next_state = 2'b00;
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (~resetn)
        current_state <= 2'b00; // Reset to state A
    else
        current_state <= next_state;
end

// Output g
assign g = (current_state == 2'b01) ? 3'b100 : // State B: g = 3'b100
           (current_state == 2'b10) ? 3'b010 : // State C: g = 3'b010
           (current_state == 2'b11) ? 3'b001 : // State D: g = 3'b001
           3'b000; // State A: g = 3'b000

endmodule