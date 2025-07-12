module TopModule(
    input  clk,
    input  reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    reg [3:0] next_q;
    if (reset) begin
        next_q = 4'd0;
    end else if (q == 4'd9) begin
        next_q = 4'd0;
    end else begin
        next_q = q + 4'd1;
    end
    q <= next_q;
end

endmodule