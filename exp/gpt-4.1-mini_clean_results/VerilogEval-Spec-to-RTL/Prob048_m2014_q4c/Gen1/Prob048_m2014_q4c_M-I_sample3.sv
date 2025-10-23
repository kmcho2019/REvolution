module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

wire enable;
assign enable = r | (d != q);

always @(posedge clk) begin
    if (enable) begin
        if (r)
            q <= 1'b0;
        else
            q <= d;
    end
end

endmodule