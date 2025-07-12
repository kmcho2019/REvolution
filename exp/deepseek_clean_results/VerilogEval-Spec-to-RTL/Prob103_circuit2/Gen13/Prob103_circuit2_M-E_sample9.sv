module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // 16:1 multiplexer implementation of the truth table
    assign q = ( {a,b,c,d} == 4'b0000 ) ? 1'b1 :
               ( {a,b,c,d} == 4'b0001 ) ? 1'b0 :
               ( {a,b,c,d} == 4'b0010 ) ? 1'b0 :
               ( {a,b,c,d} == 4'b0011 ) ? 1'b1 :
               ( {a,b,c,d} == 4'b0100 ) ? 1'b0 :
               ( {a,b,c,d} == 4'b0101 ) ? 1'b1 :
               ( {a,b,c,d} == 4'b0110 ) ? 1'b1 :
               ( {a,b,c,d} == 4'b0111 ) ? 1'b0 :
               ( {a,b,c,d} == 4'b1000 ) ? 1'b0 :
               ( {a,b,c,d} == 4'b1001 ) ? 1'b1 :
               ( {a,b,c,d} == 4'b1010 ) ? 1'b1 :
               ( {a,b,c,d} == 4'b1011 ) ? 1'b0 :
               ( {a,b,c,d} == 4'b1100 ) ? 1'b1 :
               ( {a,b,c,d} == 4'b1101 ) ? 1'b0 :
               ( {a,b,c,d} == 4'b1110 ) ? 1'b0 :
                                         1'b1;  // 1111 case

endmodule