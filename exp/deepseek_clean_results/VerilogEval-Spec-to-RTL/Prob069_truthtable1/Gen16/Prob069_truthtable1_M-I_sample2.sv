module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);
    // Alternative AND-OR implementation
    // f = (~x3 & x2) | (x3 & x1)
    assign f = (~x3 & x2) | (x3 & x1);
endmodule