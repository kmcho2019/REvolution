module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state, next_state;

// State table
always @(*)
begin
    case(state)
        2'b00: // State A
            if (r[0])
                next_state = 2'b01; // State B
            else if (r[1])
                next_state = 2'b10; // State C
            else if (r[2])
                next_state = 2'b00; // Stay in State A
            else
                next_state = 2'b00; // Stay in State A
        2'b01: // State B
            if (r[0])
                next_state = 2'b01; // Stay in State B
            else
                next_state = 2'b00; // Go to State A
        2'b10: // State C
            if (r[1])
                next_state = 2'b10; // Stay in State C
            else
                next_state = 2'b00; // Go to State A
        default:
            next_state = 2'b00;
    endcase
end

// State flip-flops
always @(posedge clk)
begin
    if (!resetn)
        state <= 2'b00; // Reset to State A
    else
        state <= next_state;
end

// Output logic
assign g[0] = (state == 2'b01); // State B
assign g[1] = (state == 2'b10); // State C
assign g[2] = 1'b0; // Always 0

endmodule