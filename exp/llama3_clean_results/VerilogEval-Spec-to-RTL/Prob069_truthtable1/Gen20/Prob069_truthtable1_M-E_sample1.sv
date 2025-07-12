module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Alternative implementation based on the conditions leading to f = 1
assign f = ((~x3) & x2) | (x3 & x1);

// Alternatively, using a more explicit conditional statement
// assign f = (x3) ? x1 : x2;

endmodule