module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// Output 'z' is asserted when the 2-bit inputs A and B are exactly equal.
// Using direct equality operator to leverage synthesis tool optimizations
// for minimal combinational logic, power, and area.
assign z = (A == B);

endmodule