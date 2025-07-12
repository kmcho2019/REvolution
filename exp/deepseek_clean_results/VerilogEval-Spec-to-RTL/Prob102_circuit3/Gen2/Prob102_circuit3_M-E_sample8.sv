module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);
    wire or_ab, or_cd;
    
    // Implement OR functions using multiplexers
    assign or_ab = a ? 1'b1 : b;
    assign or_cd = c ? 1'b1 : d;
    
    // Final AND using multiplexer
    assign q = or_cd ? or_ab : 1'b0;
endmodule