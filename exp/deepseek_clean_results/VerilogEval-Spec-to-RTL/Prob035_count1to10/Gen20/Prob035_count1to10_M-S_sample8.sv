module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset)
        q <= 4'd1;
    else if (q[3])  // Only check q[3] for count=10 (1010)
        q <= 4'd1;
    else
        q <= q + 4'd1;
end

endmodule