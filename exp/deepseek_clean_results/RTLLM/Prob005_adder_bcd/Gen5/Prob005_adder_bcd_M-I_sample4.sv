module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [3:0] binary_sum;
    wire carry_out;
    wire correction_needed;

    // Perform 4-bit addition
    assign {carry_out, binary_sum} = A + B + Cin;

    // Efficient correction detection (sum > 9 or carry out)
    assign correction_needed = carry_out | (binary_sum[3] & (binary_sum[2] | binary_sum[1]));

    // Single adder for both cases (muxed input)
    assign Sum = correction_needed ? (binary_sum + 4'd6) : binary_sum;
    
    // Carry generation
    assign Cout = correction_needed;

endmodule