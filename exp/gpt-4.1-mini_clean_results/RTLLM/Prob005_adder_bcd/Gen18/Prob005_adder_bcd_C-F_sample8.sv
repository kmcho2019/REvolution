module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    // Step 1: Perform 4-bit binary addition plus carry-in, 5-bit result to capture carry-out
    wire [4:0] raw_sum = A + B + Cin;

    // Step 2: Efficient correction detection (raw_sum > 9) using optimized Boolean logic
    wire correction_needed = raw_sum[4] | (raw_sum[3] & (raw_sum[2] | raw_sum[1]));

    // Step 3: Conditionally add correction (6) to the lower 4 bits of raw_sum if needed
    wire [4:0] corrected_sum = raw_sum + (correction_needed ? 5'd6 : 5'd0);

    // Outputs
    assign Sum  = corrected_sum[3:0];
    // Cout is set if raw carry out or correction carry out occurs
    assign Cout = raw_sum[4] | corrected_sum[4];

endmodule