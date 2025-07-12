module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge clk or posedge ar)
    if (ar) q <= 0; 
    else if (clk) q <= d;

endmodule