module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] current_state; // current state
reg [1:0] next_state; // next state

// State table
always @(*)
begin
    case (current_state)
        2'b00: // State A
            if (~r[0] && ~r[1] && ~r[2])
                next_state = 2'b00;
            else if (r[0])
                next_state = 2'b01; // Grant access to device 0
            else if (r[1])
                next_state = 2'b10; // Grant access to device 1
            else
                next_state = 2'b11; // Grant access to device 2
        2'b01: // State B
            if (r[0])
                next_state = 2'b01; // Continue granting access to device 0
            else
                next_state = 2'b00; // Revert to State A
        2'b10: // State C
            if (r[1])
                next_state = 2'b10; // Continue granting access to device 1
            else
                next_state = 2'b00; // Revert to State A
        2'b11: // State D
            if (r[2])
                next_state = 2'b11; // Continue granting access to device 2
            else
                next_state = 2'b00; // Revert to State A
        default:
            next_state = 2'b00; // Default to State A
    endcase
end

// State flip-flops
always @(posedge clk)
begin
    if (~resetn)
        current_state <= 2'b00; // Reset to State A
    else
        current_state <= next_state;
end

// Output g
assign g[0] = (current_state == 2'b01); // Grant access to device 0
assign g[1] = (current_state == 2'b10); // Grant access to device 1
assign g[2] = (current_state == 2'b11); // Grant access to device 2

endmodule