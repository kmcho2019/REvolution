module TopModule (
    input  wire a, b, c, d,
    output wire q
);

    assign q = b | c;

endmodule