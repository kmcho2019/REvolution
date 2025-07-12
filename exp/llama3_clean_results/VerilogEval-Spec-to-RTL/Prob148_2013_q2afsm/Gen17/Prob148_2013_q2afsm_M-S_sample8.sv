module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] next_state;

always @(*) begin
    case (state)
        2'b00: next_state = (r[0])? 2'b01 : (r[1])? 2'b10 : (r[2])? 2'b11 : 2'b00;
        2'b01: next_state = (r[0])? 2'b01 : 2'b00;
        2'b10: next_state = (r[1])? 2'b10 : 2'b00;
        2'b11: next_state = (r[2])? 2'b11 : 2'b00;
        default: next_state = 2'b00;
    endcase
end

always @(posedge clk) begin
    if (~resetn) state <= 2'b00;
    else state <= next_state;
end

assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = (state == 2'b11);

endmodule