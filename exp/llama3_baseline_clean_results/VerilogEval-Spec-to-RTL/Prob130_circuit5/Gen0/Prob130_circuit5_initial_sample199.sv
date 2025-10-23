module TopModule(a, b, c, d, e, q);
    input [3:0] a, b, c, d, e;
    output [3:0] q;
    wire [3:0] result;

    assign result = (c == 4'b0000) ? b :
                   (c == 4'b0001) ? e :
                   (c == 4'b0010) ? a :
                   (c == 4'b0011) ? d :
                   4'b1111; // default value f

    assign q = result;

endmodule