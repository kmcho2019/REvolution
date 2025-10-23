module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

always @(*) begin
    if (ar) begin
        q = 1'b0;
    end
end

always @(posedge clk) begin
    if (!ar) begin
        q <= d;
    end
end

endmodule