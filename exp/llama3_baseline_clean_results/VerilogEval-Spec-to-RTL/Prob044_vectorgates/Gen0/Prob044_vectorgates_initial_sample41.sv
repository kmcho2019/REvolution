module TopModule(
    input  [2:0] a,
    input  [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

// Perform bitwise-OR operation between 'a' and 'b'
assign out_or_bitwise = a | b;

// Perform logical-OR operation between 'a' and 'b'
assign out_or_logical = (a != 3'b0) || (b != 3'b0);

// Compute the inverse (NOT) of 'a' and 'b' and assign them to 'out_not'
assign out_not = {~b, ~a};

endmodule