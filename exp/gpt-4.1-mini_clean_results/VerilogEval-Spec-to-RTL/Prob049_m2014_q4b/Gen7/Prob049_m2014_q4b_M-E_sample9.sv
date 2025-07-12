module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

wire d_gated = ar ? 1'b0 : d;

always @(posedge clk or posedge ar) begin
    if (ar)
        q <= 1'b0;
    else
        q <= d_gated;
end

endmodule