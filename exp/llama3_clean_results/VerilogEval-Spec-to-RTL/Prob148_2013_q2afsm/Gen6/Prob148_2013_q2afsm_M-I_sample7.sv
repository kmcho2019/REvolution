module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// State encoding: A = 2'b00, B = 2'b01, C = 2'b10
reg [1:0] state;
reg [1:0] next_state;

// Next state logic
always @(*)
begin
    case (state)
        2'b00:  // State A
            next_state = (r[0] ? 2'b01 : (r[1] ? 2'b10 : (r[2] ? 2'b11 : 2'b00)));
        2'b01:  // State B
            next_state = r[0] ? 2'b01 : 2'b00;
        2'b10:  // State C
            next_state = r[1] ? 2'b10 : 2'b00;
        2'b11:  // State D
            next_state = r[2] ? 2'b11 : 2'b00;
        default:
            next_state = 2'b00;  // Default to state A
    endcase
end

// Output logic
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = (state == 2'b11);

// State register
always @(posedge clk)
begin
    if (~resetn)
        state <= 2'b00;  // Reset to state A
    else
        state <= next_state;
end

endmodule