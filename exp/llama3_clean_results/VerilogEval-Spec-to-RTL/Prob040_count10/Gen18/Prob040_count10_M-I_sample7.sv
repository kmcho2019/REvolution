module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 4'd0;
    end else begin
        state <= (state == 4'd9) ? 4'd0 : state + 1;
    end
end

assign q = state;

endmodule