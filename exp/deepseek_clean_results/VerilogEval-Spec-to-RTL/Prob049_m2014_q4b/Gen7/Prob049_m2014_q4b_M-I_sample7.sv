module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

parameter RESET_VALUE = 1'b0;

always @(posedge clk or posedge ar)
    if (ar) q <= RESET_VALUE;
    else    q <= d;

endmodule