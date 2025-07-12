module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [2:0] state;
reg [2:0] next_state;

always @(*) begin
    next_state = 3'b000;
    if (r[0]) next_state = 3'b001;
    else if (r[1]) next_state = 3'b010;
    else if (r[2]) next_state = 3'b011;
end

always @(posedge clk) begin
    if (~resetn) state <= 3'b000;
    else state <= next_state;
end

assign g[0] = (state == 3'b001) || (r[0] && (state == 3'b001));
assign g[1] = (state == 3'b010) || (r[1] && (state == 3'b010));
assign g[2] = (state == 3'b011) || (r[2] && (state == 3'b011));

endmodule