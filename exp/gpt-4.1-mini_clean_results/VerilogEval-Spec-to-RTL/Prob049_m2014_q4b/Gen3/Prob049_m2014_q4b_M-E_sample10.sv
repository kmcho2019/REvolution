module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

// Asynchronous reset logic (combinational-style)
always @(*) begin
    if (ar)
        q = 1'b0;
end

// Data capture on positive clock edge
always @(posedge clk) begin
    if (!ar)
        q <= d;
end

endmodule