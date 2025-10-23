module TopModule (
    input clk,
    input ar,
    input d,
    output reg q = 1'b0  // Explicit initialization for better synthesis control
);

always @(posedge clk or posedge ar)
    if (ar) q <= 1'b0;
    else    q <= d;

endmodule