module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Using a conditional operator to compute the output 'q'
assign q = ((a || b) && (c || d))? 1'b1 : 1'b0;

endmodule