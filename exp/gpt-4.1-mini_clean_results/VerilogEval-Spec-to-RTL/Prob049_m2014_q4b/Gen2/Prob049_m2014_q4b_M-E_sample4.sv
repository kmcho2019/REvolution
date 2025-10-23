module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

// Asynchronous reset logic separate from clocked data capture.
// When ar is asserted, force q to 0 immediately.
// On positive edge of clk, if not reset, capture d.
always @(*) begin
    if (ar)
        q = 1'b0;
end

always @(posedge clk) begin
    if (!ar)
        q <= d;
end

endmodule