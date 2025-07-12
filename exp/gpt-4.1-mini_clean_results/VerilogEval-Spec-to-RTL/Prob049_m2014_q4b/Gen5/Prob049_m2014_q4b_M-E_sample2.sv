module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

// Asynchronous reset: whenever ar is asserted, q is immediately reset to 0
always @(posedge clk) begin
    if (!ar)
        q <= d;
end

always @(ar) begin
    if (ar)
        q <= 1'b0;
end

endmodule