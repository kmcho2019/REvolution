module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

wire ce = (q != d);  // Clock enable when data changes

always @(posedge clk or posedge ar)
    if (ar)      q <= 1'b0;
    else if (ce) q <= d;

endmodule