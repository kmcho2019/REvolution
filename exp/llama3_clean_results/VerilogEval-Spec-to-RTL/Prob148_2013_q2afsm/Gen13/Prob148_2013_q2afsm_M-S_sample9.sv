module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] next_state;

// Next state logic
always @(posedge clk) begin
    if (~resetn) state <= 2'b00;
    else state <= next_state;
end

always @(*) begin
    case (state)
        2'b00: 
            if (r[0]) next_state = 2'b01;
            else if (r[1]) next_state = 2'b10;
            else if (r[2]) next_state = 2'b11;
            else next_state = 2'b00;
        2'b01: if (!r[0]) next_state = 2'b00; else next_state = 2'b01;
        2'b10: if (!r[1]) next_state = 2'b00; else next_state = 2'b10;
        default: next_state = 2'b00;
    endcase
end

// Output logic
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = (state == 2'b11);

endmodule