module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

assign out_and = &(in);  // Perform bitwise AND operation
assign out_or  = |(in);  // Perform bitwise OR operation
assign out_xor = ^(in); // Perform bitwise XOR operation

endmodule