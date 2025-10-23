module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [2:0] state, next_state;

always @(posedge clk) begin
    if (~resetn) state <= 3'b000;
    else state <= next_state;
end

assign next_state = (
    (state == 3'b000 && r[0]) ? 3'b001 :
    (state == 3'b000 && !r[0] && r[1]) ? 3'b010 :
    (state == 3'b000 && !r[0] && !r[1] && r[2]) ? 3'b011 :
    (state == 3'b001 && !r[0]) ? 3'b000 :
    (state == 3'b010 && !r[1]) ? 3'b000 :
    (state == 3'b011 && !r[2]) ? 3'b000 :
    state
);

assign g[0] = (state == 3'b001);
assign g[1] = (state == 3'b010);
assign g[2] = (state == 3'b011);

endmodule