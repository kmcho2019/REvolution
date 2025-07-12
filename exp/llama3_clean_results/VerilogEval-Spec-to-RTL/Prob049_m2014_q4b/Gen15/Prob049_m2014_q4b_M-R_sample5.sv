module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

always @(*) // Asynchronous reset
    if (ar) q <= 0;

always @(posedge clk) // Synchronous update
    if (!ar) q <= d;

endmodule