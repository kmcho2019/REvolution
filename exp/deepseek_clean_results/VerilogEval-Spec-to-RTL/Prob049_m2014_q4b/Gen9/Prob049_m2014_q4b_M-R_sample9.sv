module TopModule (
    input clk,
    input ar,
    input d,
    output reg q = 1'b0
);

wire next_q;

assign next_q = ar ? 1'b0 : d;

always @(posedge clk or posedge ar)
    q <= next_q;

endmodule