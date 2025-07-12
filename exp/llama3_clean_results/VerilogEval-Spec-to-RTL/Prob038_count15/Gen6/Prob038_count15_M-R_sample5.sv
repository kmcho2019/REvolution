module TopModule(
    input  clk,
    input  reset,
    output reg [3:0] q = 4'd0
);

reg [3:0] next_q;

always @(*) begin
    if (q == 4'd15) begin
        next_q = 4'd0;
    end else begin
        next_q = q + 1;
    end
end

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;
    end else begin
        q <= next_q;
    end
end

endmodule