module TopModule(
    input  clk,
    input  reset,
    output reg [3:0] q
);

reg [3:0] next_q;

always @(*) begin
    if (reset || q == 4'd9) begin
        next_q = 4'd0;
    end else begin
        next_q = q + 4'd1;
    end
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule