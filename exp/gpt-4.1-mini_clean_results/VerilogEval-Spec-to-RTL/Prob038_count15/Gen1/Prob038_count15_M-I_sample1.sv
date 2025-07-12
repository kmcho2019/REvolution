module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire enable = 1'b1;

always @(posedge clk) begin
    if (reset)
        q <= 4'b0000;
    else if (enable)
        q <= q + 1;
end

endmodule