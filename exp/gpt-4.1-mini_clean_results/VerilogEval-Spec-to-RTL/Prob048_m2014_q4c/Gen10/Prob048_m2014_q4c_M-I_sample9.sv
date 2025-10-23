module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

wire next_q = r ? 1'b0 : d;
wire enable = (q !== next_q);

always @(posedge clk) begin
    if (enable)
        q <= next_q;
end

endmodule