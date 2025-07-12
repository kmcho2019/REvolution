module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

wire enable = (d != q) || r;  // Only enable when input changes or reset is active

always @(posedge clk) begin
    if (enable) begin
        if (r) begin
            q <= 1'b0;
        end
        else begin
            q <= d;
        end
    end
end

endmodule