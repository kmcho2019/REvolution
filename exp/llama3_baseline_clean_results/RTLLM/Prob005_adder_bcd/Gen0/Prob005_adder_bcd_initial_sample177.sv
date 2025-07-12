module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    reg [4:0] sum_temp; // Temporary sum to hold the result of A + B + Cin
    reg [3:0] corrected_sum; // Holds the corrected sum after BCD correction
    reg cout_temp; // Temporary carry-out

    always @(*) begin
        sum_temp = A + B + Cin; // Perform binary addition of A, B, and Cin
        if (sum_temp > 9) begin // Check if sum exceeds 9
            corrected_sum = sum_temp + 6; // Add 6 for BCD correction
            cout_temp = 1; // Set Cout to 1 if sum exceeds 9
        end else begin
            corrected_sum = sum_temp[3:0]; // Assign the sum without correction
            cout_temp = 0; // Reset Cout if sum is within BCD range
        end
        Sum = corrected_sum; // Assign the corrected sum to output Sum
        Cout = cout_temp; // Assign the temporary Cout to output Cout
    end

endmodule