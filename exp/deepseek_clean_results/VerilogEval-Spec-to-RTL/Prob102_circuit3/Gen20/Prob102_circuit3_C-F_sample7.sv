module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

    // Optimal implementation: q = (a OR b) AND (c OR d)
    assign q = (a | b) & (c | d);

    // Verification assertions (synthesis will ignore these)
    // These ensure our optimized implementation matches the truth table
    always @(*) begin
        if ({a,b,c,d} == 4'b0000) assert(q == 0);
        if ({a,b,c,d} == 4'b0001) assert(q == 0);
        if ({a,b,c,d} == 4'b0010) assert(q == 0);
        if ({a,b,c,d} == 4'b0011) assert(q == 0);
        if ({a,b,c,d} == 4'b0100) assert(q == 0);
        if ({a,b,c,d} == 4'b0101) assert(q == 1);
        if ({a,b,c,d} == 4'b0110) assert(q == 1);
        if ({a,b,c,d} == 4'b0111) assert(q == 1);
        if ({a,b,c,d} == 4'b1000) assert(q == 0);
        if ({a,b,c,d} == 4'b1001) assert(q == 1);
        if ({a,b,c,d} == 4'b1010) assert(q == 1);
        if ({a,b,c,d} == 4'b1011) assert(q == 1);
        if ({a,b,c,d} == 4'b1100) assert(q == 0);
        if ({a,b,c,d} == 4'b1101) assert(q == 1);
        if ({a,b,c,d} == 4'b1110) assert(q == 1);
        if ({a,b,c,d} == 4'b1111) assert(q == 1);
    end

endmodule