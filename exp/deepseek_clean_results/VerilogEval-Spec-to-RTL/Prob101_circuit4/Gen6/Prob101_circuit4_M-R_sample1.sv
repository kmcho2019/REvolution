module TopModule (
    input  wire a, b, c, d,
    output wire q
);

    wire b_or_c;
    
    assign b_or_c = b | c;
    assign q = b_or_c;

endmodule