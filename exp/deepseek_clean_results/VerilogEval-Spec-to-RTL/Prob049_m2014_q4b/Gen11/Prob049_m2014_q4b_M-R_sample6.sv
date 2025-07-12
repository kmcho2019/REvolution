module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

wire next_q = ar ? 1'b0 : d;

always @(posedge clk or posedge ar)
    q <= next_q;

endmodule