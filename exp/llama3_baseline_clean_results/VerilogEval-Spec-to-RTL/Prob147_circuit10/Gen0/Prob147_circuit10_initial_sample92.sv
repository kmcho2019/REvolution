module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg current_state;
reg next_state;

always @(posedge clk) begin
    current_state <= next_state;
end

always @(*) begin
    next_state = (a == 0) ? current_state : ~current_state;
    q = (current_state == 0) ? b : ~b;
end

assign state = current_state;

endmodule