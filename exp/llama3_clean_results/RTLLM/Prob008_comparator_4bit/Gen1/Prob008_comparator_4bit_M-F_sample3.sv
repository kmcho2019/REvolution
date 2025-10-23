// Define the full_adder module separately
module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

// Define the comparator_4bit module
module comparator_4bit(
    input [3:0] A,  // First 4-bit input operand
    input [3:0] B,  // Second 4-bit input operand
    output reg A_greater,  // 1-bit output indicating if A is greater than B
    output reg A_equal,   // 1-bit output indicating if A is equal to B
    output reg A_less    // 1-bit output indicating if A is less than B
);

// Perform subtraction A - B using addition with inverted B and carry-in = 1
wire [3:0] not_B;  // Inverted B
assign not_B = ~B;

wire [3:0] result;  // Result of the subtraction A - B
wire c0, c1, c2, c3;  // Carry signals

// Using a ripple-carry adder for the subtraction operation
full_adder fa0(A[0], not_B[0], 1, result[0], c0);
full_adder fa1(A[1], not_B[1], c0, result[1], c1);
full_adder fa2(A[2], not_B[2], c1, result[2], c2);
full_adder fa3(A[3], not_B[3], c2, result[3], c3);

// Determine outputs based on the result of subtraction
always @(*) begin
    if (c3) begin  // If there's a final carry-out, A is greater than B
        A_greater = 1'b1;
        A_equal = 1'b0;
        A_less = 1'b0;
    end else if (~(|result)) begin  // If result is zero and no carry-out, A is equal to B
        A_greater = 1'b0;
        A_equal = 1'b1;
        A_less = 1'b0;
    end else begin  // If result is not zero and no carry-out, A is less than B
        A_greater = 1'b0;
        A_equal = 1'b0;
        A_less = 1'b1;
    end
end

endmodule