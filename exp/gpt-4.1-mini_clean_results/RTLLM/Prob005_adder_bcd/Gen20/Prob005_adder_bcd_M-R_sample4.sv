module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] initial_sum;
    wire       need_correction;
    wire [4:0] corrected_sum_with_correction;
    wire [3:0] sum_after_correction;

    // Add inputs and carry-in
    assign initial_sum = A + B + Cin;

    // Determine if correction is needed (sum > 9)
    assign need_correction = (initial_sum > 5'd9);

    // Add 6 for correction if needed
    assign corrected_sum_with_correction = initial_sum + 5'd6;

    // Select between initial sum and corrected sum based on correction requirement
    assign sum_after_correction = need_correction ? corrected_sum_with_correction[3:0] : initial_sum[3:0];

    // Assign outputs
    assign Sum  = sum_after_correction;
    assign Cout = need_correction;

endmodule