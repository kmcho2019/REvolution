module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

// Use a simple OR gate to implement the logic
assign q = (b | c);

// Alternatively, we can use a more explicit implementation using if-else statements
// assign q = (b == 1'b1 || c == 1'b1)? 1'b1 : 1'b0;

endmodule