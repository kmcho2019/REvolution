module TopModule (
    input x,
    input y,
    output z
);

assign z = (x ^ y) & x; 
// Alternative optimized implementation (equivalent): assign z = x & ~y;

endmodule