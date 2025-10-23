module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset)
        q <= 4'd0;
    else if (q == 4'd9)  // direct comparison with terminal count
        q <= 4'd0;
    else
        q <= q + 1'd1;
end

endmodule