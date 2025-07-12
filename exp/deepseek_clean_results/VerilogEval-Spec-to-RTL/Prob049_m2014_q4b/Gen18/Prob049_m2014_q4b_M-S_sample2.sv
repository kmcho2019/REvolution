module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

always @(posedge clk or posedge ar)
    q <= ar ? 1'b0 : d;

endmodule