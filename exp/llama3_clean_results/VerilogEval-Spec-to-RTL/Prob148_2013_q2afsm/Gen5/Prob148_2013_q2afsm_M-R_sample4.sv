module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [1:0] state, next_state;

assign next_state = 
    (state == 2'b00 && r[0]) ? 2'b01 :
    (state == 2'b00 && !r[0] && r[1]) ? 2'b10 :
    (state == 2'b00 && !r[0] && !r[1] && r[2]) ? 2'b11 :
    (state == 2'b01 && r[0]) ? 2'b01 :
    (state == 2'b01 && !r[0]) ? 2'b00 :
    (state == 2'b10 && r[1]) ? 2'b10 :
    (state == 2'b10 && !r[1]) ? 2'b00 :
    (state == 2'b11 && r[2]) ? 2'b11 :
    (state == 2'b11 && !r[2]) ? 2'b00 :
    2'b00;

always @(posedge clk) begin
    if (~resetn) state <= 2'b00; // Reset to State A
    else state <= next_state;
end

assign g[0] = (state == 2'b01); // State B grants device 0
assign g[1] = (state == 2'b10); // State C grants device 1
assign g[2] = (state == 2'b11); // State D grants device 2

endmodule