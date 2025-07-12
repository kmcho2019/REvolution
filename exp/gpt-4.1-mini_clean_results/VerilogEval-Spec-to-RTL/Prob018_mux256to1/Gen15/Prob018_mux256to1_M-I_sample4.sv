module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output         out
);
    // Directly select the bit indexed by sel from the input vector using continuous assignment
    assign out = in[sel];
endmodule