module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);
    // Implement the minimized Boolean expression directly
    assign f = (~x3 & x2) | (x3 & x1);
endmodule