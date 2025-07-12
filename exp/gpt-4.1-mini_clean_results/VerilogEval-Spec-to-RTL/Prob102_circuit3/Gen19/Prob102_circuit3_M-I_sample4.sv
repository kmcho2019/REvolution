module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    output wire q
);
    wire cd_or;
    assign cd_or = c | d;
    assign q = (a & cd_or) | (b & cd_or);
endmodule