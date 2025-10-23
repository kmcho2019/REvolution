module TopModule (
    input clk,
    input ar,
    input d,
    output reg q,
    input cen = 1'b1  // Optional clock enable with default value
);

always @(posedge clk or posedge ar)
    if (ar)       q <= 1'b0;
    else if (cen) q <= d;

endmodule