module TopModule(
    input  clk,
    input  reset,
    output reg [3:0] q
);

reg [3:0] next_q;

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;
    end else begin
        q <= next_q;
    end
end

assign next_q = (q == 4'd9)? 4'd0 : q + 4'd1;

endmodule