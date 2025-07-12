module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    wire or_ab, or_cd;
    
    // Implement (a OR b) using a 2:1 mux
    assign or_ab = b ? 1'b1 : a;
    
    // Implement (c OR d) using a 2:1 mux
    assign or_cd = d ? 1'b1 : c;
    
    // Final AND operation
    assign q = or_ab & or_cd;

endmodule