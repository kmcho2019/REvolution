module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

// Instead of a comparator, detect count == 10 (4'b1010)
wire wrap = (q == 4'd10);

always @(posedge clk) begin
    if (reset)
        q <= 4'd1;
    else if (wrap)
        q <= 4'd1;
    else
        q <= q + 1'b1;
end

endmodule