module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

// Internal wires for sum and carry
wire [4:0] sum_internal;
wire [4:0] corrected_sum_internal;

// Perform binary addition of A, B, and Cin
assign sum_internal = {1'b0, A} + {1'b0, B} + {4'b0000, Cin};

// Check if sum exceeds 9 and apply correction if necessary
assign corrected_sum_internal = (sum_internal > 9) ? sum_internal + 6 : sum_internal;

// Assign Sum and Cout based on the corrected sum
assign Sum = corrected_sum_internal[3:0];
assign Cout = (sum_internal > 9 || corrected_sum_internal > 9) ? 1'b1 : 1'b0;

endmodule