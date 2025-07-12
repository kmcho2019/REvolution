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
    end else begin
        state <= (state == STATE_B) ? (~in) : in;
    end
end

endmodule