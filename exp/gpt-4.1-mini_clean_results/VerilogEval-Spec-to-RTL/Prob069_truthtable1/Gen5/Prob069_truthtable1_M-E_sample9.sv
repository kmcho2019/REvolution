module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);

// Encode function f by enumerating the input conditions where f=1 using nested ternary operators
assign f = (x3 == 0 && x2 == 1) ? 1'b1 :  // x3=0, x2=1, regardless of x1
           (x3 == 1 && x2 == 0 && x1 == 1) ? 1'b1 :  // x3=1, x2=0, x1=1
           (x3 == 1 && x2 == 1 && x1 == 1) ? 1'b1 :  // x3=1, x2=1, x1=1
           1'b0;  // Otherwise f=0

endmodule