module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    output wire q
);

assign q = b | c;

endmodule