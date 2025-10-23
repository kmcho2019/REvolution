module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire or_ab, or_cd;
    
    // Implement (a OR b) using a 2:1 MUX
    assign or_ab = a ? 1'b1 : b;
    
    // Implement (c OR d) using a 2:1 MUX
    assign or_cd = c ? 1'b1 : d;
    
    // Final AND operation
    assign q = or_ab & or_cd;

endmodule