module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset)
        q <= 4'b0001;
    else if (q[3])  // Simplified wrap-around at 10 (only need to check q[3])
        q <= 4'b0001;
    else
        q <= q + 4'b0001;
end

endmodule