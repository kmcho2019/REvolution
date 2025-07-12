module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset)
        q <= 4'b0000;
    else if (q == 4'b1001)  // terminal count (9)
        q <= 4'b0000;
    else
        q <= q + 1'b1;
end

endmodule