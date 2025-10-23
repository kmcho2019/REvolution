module TopModule(
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_or_bitwise,
    output out_or_logical,
    output [5:0] out_not
);

// Perform bitwise OR operation on 'a' and 'b'
assign out_or_bitwise = a | b;

// Perform logical OR operation on 'a' and 'b'
assign out_or_logical = (a!= 3'b000) || (b!= 3'b000);

// Perform NOT operation on 'a' and 'b'
assign out_not[5:3] = ~b;
assign out_not[2:0] = ~a;

endmodule