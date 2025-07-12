module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk) begin
    if (r)
        q <= 1'b0;
end

always @(posedge clk) begin
    if (!r)
        q <= d;
end

endmodule