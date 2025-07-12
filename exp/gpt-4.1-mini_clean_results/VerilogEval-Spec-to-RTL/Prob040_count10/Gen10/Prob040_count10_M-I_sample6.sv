module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire clk_en = (q != 4'd9);

always @(posedge clk) begin
    if (reset)
        q <= 4'd0;
    else if (clk_en)
        q <= q + 1;
end

endmodule