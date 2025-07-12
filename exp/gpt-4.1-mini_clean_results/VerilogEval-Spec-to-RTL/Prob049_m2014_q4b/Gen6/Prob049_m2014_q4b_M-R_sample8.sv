module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

// Asynchronous reset logic
always @(posedge clk) begin
    if (!ar)
        q <= d;
end

always @(posedge ar) begin
    q <= 1'b0;
end

endmodule