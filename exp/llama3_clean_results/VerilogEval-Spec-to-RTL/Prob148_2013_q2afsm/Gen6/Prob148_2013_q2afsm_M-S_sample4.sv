module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] next_state;

always @(*) begin
    case (1'b1)
        r[0]: next_state = 2'b01;
        r[1]: next_state = 2'b10;
        r[2]: next_state = 2'b11;
        default: next_state = 2'b00;
    endcase
end

always @(posedge clk) begin
    if (~resetn) state <= 2'b00;
    else state <= next_state;
end

assign g[0] = (state == 2'b01) & r[0];
assign g[1] = (state == 2'b10) & r[1];
assign g[2] = (state == 2'b11) & r[2];

endmodule