module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] next_state;

// Simplified priority encoder logic
always @(*) begin
    if (r[0]) next_state = 2'b01;
    else if (r[1]) next_state = 2'b10;
    else if (r[2]) next_state = 2'b11;
    else next_state = 2'b00;
end

// State flip-flops with clock gating
always @(posedge clk) begin
    if (~resetn) state <= 2'b00;
    else if (state == 2'b00) state <= next_state;
    else if ((state == 2'b01 && !r[0]) || (state == 2'b10 && !r[1]) || (state == 2'b11 && !r[2])) state <= 2'b00;
    else state <= state;
end

// Output assignments
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = (state == 2'b11);

endmodule