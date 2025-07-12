module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state, next_state;

// State table (combinational logic)
always @(*)
begin
    case (state)
        2'b00: // State A
            if (r[0] == 1'b1)
                next_state = 2'b01; // State B
            else if (r[1] == 1'b1)
                next_state = 2'b10; // State C
            else if (r[2] == 1'b1)
                next_state = 2'b11; // State D
            else
                next_state = 2'b00; // Stay in State A
        2'b01: // State B
            if (r[0] == 1'b1)
                next_state = 2'b01; // Stay in State B
            else
                next_state = 2'b00; // Go back to State A
        2'b10: // State C
            if (r[1] == 1'b1)
                next_state = 2'b10; // Stay in State C
            else
                next_state = 2'b00; // Go back to State A
        2'b11: // State D
            // Not needed in this case, but added for completeness
            next_state = 2'b00; // Go back to State A (not actually reachable)
        default:
            next_state = 2'b00; // Default to State A
    endcase
end

// State flip-flops (sequential logic)
always @(posedge clk)
begin
    if (~resetn)
        state <= 2'b00; // Reset to State A
    else
        state <= next_state;
end

// Outputs (combinational logic)
always @(*)
begin
    case (state)
        2'b00: // State A
            g <= 3'b000;
        2'b01: // State B
            g <= 3'b100;
        2'b10: // State C
            g <= 3'b010;
        2'b11: // State D
            g <= 3'b001;
        default:
            g <= 3'b000; // Default to all zeros
    endcase
end

endmodule