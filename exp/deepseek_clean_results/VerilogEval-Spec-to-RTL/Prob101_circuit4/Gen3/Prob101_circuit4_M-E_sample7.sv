module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Novel implementation using priority encoding
    assign q = (a == 0) ? (b | c) : 
               (b & c) ? 1'b1 :
               (b ^ c) ? d : 
               1'b0;

endmodule