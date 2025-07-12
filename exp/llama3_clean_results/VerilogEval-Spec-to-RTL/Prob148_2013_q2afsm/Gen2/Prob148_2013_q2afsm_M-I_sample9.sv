module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [2:0] state;
reg [2:0] next_state;
reg clk_enable;

always @(*) begin
    next_state = state;
    
    if (r[0] && state!= 3'b001) next_state = 3'b001;
    else if (r[1] && state!= 3'b010) next_state = 3'b010;
    else if (r[2] && state!= 3'b011) next_state = 3'b011;
    else if (!r[0] && state == 3'b001) next_state = 3'b000;
    else if (!r[1] && state == 3'b010) next_state = 3'b000;
    else if (!r[2] && state == 3'b011) next_state = 3'b000;
end

always @(posedge clk) begin
    if (~resetn) state <= 3'b000;
    else state <= next_state;
end

assign g[0] = (state == 3'b001);
assign g[1] = (state == 3'b010);
assign g[2] = (state == 3'b011);

// Clock gating: Enable clock only when state needs to change
always @(*) begin
    if (next_state!= state || ~resetn) clk_enable = 1'b1;
    else clk_enable = 1'b0;
end

// For synthesis, the clock gating would be applied to the clock signal itself,
// but for simulation purposes, we keep the original clock signal.
// In a real implementation, you would use clk_enable to gate the clock.

endmodule