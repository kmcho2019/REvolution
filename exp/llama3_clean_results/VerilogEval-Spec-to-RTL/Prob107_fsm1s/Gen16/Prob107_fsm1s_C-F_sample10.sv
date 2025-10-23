module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

parameter STATE_B = 0, STATE_A = 1;
reg state;

assign out = (state == STATE_B) ? 1'b1 : 1'b0;

always @(posedge clk) begin
    if (reset) begin
        state <= STATE_B;
    end else begin
        state <= (state == STATE_B && in == 0) ? STATE_A : 
                 (state == STATE_B && in == 1) ? STATE_B : 
                 (state == STATE_A && in == 0) ? STATE_B : 
                 (state == STATE_A && in == 1) ? STATE_A : STATE_B;
    end
end

endmodule