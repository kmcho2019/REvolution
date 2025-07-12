module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [2:0] state;

always @(*) begin
    if (r[0]) state = 3'b001;
    else if (r[1]) state = 3'b010;
    else if (r[2]) state = 3'b011;
    else state = 3'b000;
end

always @(posedge clk) begin
    if (~resetn) state <= 3'b000;
    else if (state == 3'b001 && !r[0]) state <= 3'b000;
    else if (state == 3'b010 && !r[1]) state <= 3'b000;
    else if (state == 3'b011 && !r[2]) state <= 3'b000;
end

assign g[0] = (state == 3'b001);
assign g[1] = (state == 3'b010);
assign g[2] = (state == 3'b011);

endmodule