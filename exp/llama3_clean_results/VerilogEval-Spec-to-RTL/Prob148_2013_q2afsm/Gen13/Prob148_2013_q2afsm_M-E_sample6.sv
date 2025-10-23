module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] next_state;

always @(*)
begin
    case (state)
        2'b00:  // State A
            if (r[0])
                next_state = 2'b01;
            else if (r[1])
                next_state = 2'b10;
            else if (r[2])
                next_state = 2'b11;
            else
                next_state = 2'b00;
        2'b01:  // State B
            if (r[0])
                next_state = 2'b01;
            else
                next_state = 2'b00;
        2'b10:  // State C
            if (r[1])
                next_state = 2'b10;
            else
                next_state = 2'b00;
        2'b11:  // State D
            if (r[2])
                next_state = 2'b11;
            else
                next_state = 2'b00;
        default:
            next_state = 2'b00;  // Default to state A
    endcase
end

always @(posedge clk)
begin
    if (~resetn)
        state <= 2'b00;  // Reset to state A
    else
        state <= next_state;
end

assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = (state == 2'b11);

endmodule