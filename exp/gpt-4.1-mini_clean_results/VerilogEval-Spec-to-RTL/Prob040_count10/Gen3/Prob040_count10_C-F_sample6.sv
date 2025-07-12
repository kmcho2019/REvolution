module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

localparam MAX_COUNT = 4'd9;

always @(posedge clk) begin
    if (reset)
        q <= 4'd0;
    else if (q == MAX_COUNT)
        q <= 4'd0;
    else
        q <= q + 4'd1;
end

endmodule