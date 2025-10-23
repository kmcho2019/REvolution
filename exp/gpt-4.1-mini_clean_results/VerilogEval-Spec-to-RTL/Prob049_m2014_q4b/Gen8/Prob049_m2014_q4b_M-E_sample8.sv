module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

// Asynchronous reset process
always @(ar) begin
    if (ar)
        q <= 1'b0;
end

// Data capture process on positive clock edge when not in reset
always @(posedge clk) begin
    if (!ar)
        q <= d;
end

endmodule