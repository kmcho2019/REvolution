module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] next_state;

// State table (next state logic)
always @(*)
begin
    case(state)
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
        state <= 2'b00; // Reset to state A
    else
        state <= next_state;
end

// Output logic
assign g[0] = (state == 2'b01); // g0 is high in state B
assign g[1] = (state == 2'b10); // g1 is high in state C
assign g[2] = 1'b0; // g2 is always low

endmodule