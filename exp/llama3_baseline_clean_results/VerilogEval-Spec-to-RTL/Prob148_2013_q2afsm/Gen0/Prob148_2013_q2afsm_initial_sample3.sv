module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] current_state;
reg [1:0] next_state;

// Continuous assignment for output signals
assign g[0] = (current_state == 2'b01)? 1'b1 : 1'b0;
assign g[1] = (current_state == 2'b10)? 1'b1 : 1'b0;
assign g[2] = 1'b0; // Based on the problem description, g[2] is always 0

// State table
always @(*)
begin
    case (current_state)
        2'b00: // State A
            if (r[0] == 1'b1)
                next_state = 2'b01; // State B
            else if (r[1] == 1'b1)
                next_state = 2'b10; // State C
            else
                next_state = 2'b00; // State A
        2'b01: // State B
            if (r[0] == 1'b1)
                next_state = 2'b01; // State B
            else
                next_state = 2'b00; // State A
        2'b10: // State C
            if (r[1] == 1'b1)
                next_state = 2'b10; // State C
            else
                next_state = 2'b00; // State A
        default:
            next_state = 2'b00; // State A
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

endmodule