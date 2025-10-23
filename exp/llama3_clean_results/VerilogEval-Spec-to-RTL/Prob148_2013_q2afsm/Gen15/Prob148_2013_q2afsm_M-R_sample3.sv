module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// State encoding: A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11
reg [1:0] state;
reg [1:0] next_state;

// Next state logic
assign next_state = (
    (state == 2'b00 && r[0]) ? 2'b01 : // A to B
    (state == 2'b00 && ~r[0] && r[1]) ? 2'b10 : // A to C
    (state == 2'b00 && ~r[0] && ~r[1] && r[2]) ? 2'b11 : // A to D
    (state == 2'b01 && r[0]) ? 2'b01 : // B to B
    (state == 2'b01 && ~r[0]) ? 2'b00 : // B to A
    (state == 2'b10 && r[1]) ? 2'b10 : // C to C
    (state == 2'b10 && ~r[1]) ? 2'b00 : // C to A
    (state == 2'b11 && r[2]) ? 2'b11 : // D to D
    2'b00 // Default to A
);

// Output logic
assign g[0] = (state == 2'b01); // g[0] is high in state B
assign g[1] = (state == 2'b10); // g[1] is high in state C
assign g[2] = (state == 2'b11); // g[2] is high in state D

// State register
always @(posedge clk)
begin
    if (~resetn)
        state <= 2'b00;  // Reset to state A
    else
        state <= next_state;
end

endmodule