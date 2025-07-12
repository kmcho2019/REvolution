module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

assign q = ar ? 1'b0 : q;

always @(posedge clk) begin
    if (!ar) begin
        q <= d;
    end
end

endmodule