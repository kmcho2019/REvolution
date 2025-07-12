module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire cd_or; // Intermediate variable to hold (c || d)
assign cd_or = c || d;
assign q = (b && cd_or) || (a && cd_or);

endmodule