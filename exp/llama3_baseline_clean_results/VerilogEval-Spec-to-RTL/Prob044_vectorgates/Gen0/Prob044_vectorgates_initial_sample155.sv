module TopModule(
    input  [2:0] a,       // 3-bit input vector a
    input  [2:0] b,       // 3-bit input vector b
    output [2:0] out_or_bitwise,  // 3-bit output for bitwise OR of a and b
    output out_or_logical,       // 1-bit output for logical OR of a and b
    output [5:0] out_not          // 6-bit output for NOT of a and b
);

// Calculate bitwise OR of a and b
assign out_or_bitwise = a | b;

// Calculate logical OR of a and b
assign out_or_logical = (a != 3'b000) || (b != 3'b000);

// Calculate NOT of a and b and combine
assign out_not = {~b, ~a};

endmodule