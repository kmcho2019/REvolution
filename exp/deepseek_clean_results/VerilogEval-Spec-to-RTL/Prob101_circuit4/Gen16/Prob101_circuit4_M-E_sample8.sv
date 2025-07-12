module TopModule (input a, b, c, d, output q);
    assign q = b ? 1'b1 : 
               c ? 1'b1 : 
               (a & ~d) ? 1'b0 : 1'b0;
endmodule