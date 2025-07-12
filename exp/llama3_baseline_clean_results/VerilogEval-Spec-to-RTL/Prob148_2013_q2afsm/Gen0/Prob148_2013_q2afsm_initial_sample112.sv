module TopModule(
    input  clk,
    input  resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] next_state;

// Continuous assignment for outputs
assign g = (state == 2'b01) ? 3'b100 : 
           (state == 2'b10) ? 3'b010 : 
           3'b000;

// Next state logic
always @(*)
begin
    case(state)
        2'b00: // State A
            if (~r[0] && ~r[1] && ~r[2])
                next_state = 2'b00;
            else if (r[0])
                next_state = 2'b01;
            else if (r[1])
                next_state = 2'b10;
            else if (r[2])
                next_state = 2'b11;
        2'b01: // State B
            if (r[0])
                next_state = 2'b01;
            else
                next_state = 2'b00;
        2'b10: // State C
            if (r[1])
                next_state = 2'b10;
            else
                next_state = 2'b00;
        2'b11: // State D
            next_state = 2'b00; // Default to A, as there's no transition from D in the given diagram
        default:
            next_state = 2'b00;
    endcase
end

// State flip-flops
always @(posedge clk)
begin
    if (~resetn)
        state <= 2'b00;
    else
        state <= next_state;
end

endmodule