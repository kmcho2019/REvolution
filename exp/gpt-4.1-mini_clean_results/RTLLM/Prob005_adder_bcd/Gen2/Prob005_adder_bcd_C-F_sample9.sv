module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] raw_sum;
    wire       correction_needed;
    wire [4:0] corrected_sum;

    // Binary addition of A, B, and Cin
    assign raw_sum = A + B + Cin;

    // Correction is needed if raw sum > 9 or carry out (bit 4) is set
    assign correction_needed = (raw_sum[4]) | (raw_sum[3:0] > 4'd9);

    // Apply BCD correction (+6) if needed
    assign corrected_sum = correction_needed ? (raw_sum + 5'd6) : raw_sum;

    // Output lower 4 bits as sum
    assign Sum = corrected_sum[3:0];

    // Carry out if corrected sum has overflow
    assign Cout = corrected_sum[4];

endmodule