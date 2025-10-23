module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Implement as 4:1 mux where:
    // sel[1] = x3, sel[0] = x2
    // inputs are set based on x1's effect in each case
    assign f = (x3 & x2) ? x1 :       // When x3=1,x2=1: f=x1 (last two rows)
               (x3)      ? x1 :       // When x3=1,x2=0: f=x1 (rows 5-6)
               (x2)      ? 1'b1 :     // When x3=0,x2=1: f=1 (rows 3-4)
                          1'b0;      // When x3=0,x2=0: f=0 (rows 1-2)
endmodule