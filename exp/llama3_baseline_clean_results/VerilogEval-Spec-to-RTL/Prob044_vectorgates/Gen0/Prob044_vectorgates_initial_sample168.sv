module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output        out_or_logical,
    output [5:0] out_not
);

// Perform bitwise OR operation between a and b
assign out_or_bitwise = a | b;

// Perform logical OR operation between a and b
// $signed() and $unsigned() can be used for type casting, 
// but here we are dealing with simple logical operations
// so it's not required
assign out_or_logical = (a != 3'b000) || (b != 3'b000);

// Compute the inverse of a and b
assign out_not = {~b, ~a};

endmodule