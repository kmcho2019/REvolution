module TopModule(
    input clk,
    input d,
    output reg q
);

// Utilize a non-blocking assignment within an always block to update the output
always @(posedge clk)
    q <= d;

endmodule