module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

assign q = ar ? 0 : q;

always @(posedge clk) begin
    if (!ar) begin
        q <= d;
    end
end

endmodule