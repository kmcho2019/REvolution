module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Intermediate signals
    wire [3:0] raw_sum;
    wire carry_out;
    wire needs_correction;
    wire [3:0] correction_value;

    // Calculate raw binary sum (4-bit + 4-bit + 1-bit)
    assign raw_sum = A + B + Cin;

    // Determine if correction is needed (sum > 9 or carry generated)
    assign needs_correction = (raw_sum > 9) || (A + B + Cin > 15);

    // Correction value is either 6 or 0
    assign correction_value = needs_correction ? 4'd6 : 4'd0;

    // Final sum after potential correction
    assign Sum = raw_sum + correction_value;

    // Carry out is set when correction is needed
    assign Cout = needs_correction;

endmodule