module TopModule (
    input [2:0] a,
    output [15:0] q
);

assign q = {16'h1232, 16'haee0, 16'h27d4, 16'h5a0e, 
            16'h2066, 16'h64ce, 16'hc526, 16'h2f19} >> (16 * a);

endmodule