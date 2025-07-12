module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

parameter STATE_B = 1'b0, STATE_A = 1'b1;
reg state;

assign out = ~state;

always @(posedge clk) begin
    if (reset) begin
        state <= STATE_B;
    end else if (state == STATE_B) begin
        state <= in? STATE_B : STATE_A;
    end else begin
        state <= in? STATE_A : STATE_B;
    end
end

endmodule