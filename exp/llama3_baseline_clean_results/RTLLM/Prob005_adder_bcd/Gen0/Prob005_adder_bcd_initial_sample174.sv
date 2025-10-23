module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,     // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the BCD sum
    output Cout      // Carry-out output
);

    reg [3:0] temp_sum;  // Temporary sum for binary addition
    reg [3:0] corrected_sum;  // Sum after applying BCD correction
    reg carry_out;  // Carry-out after BCD correction

    // Perform binary addition of A, B, and Cin
    always @(A or B or Cin) begin
        temp_sum = A + B + Cin;
    end

    // Apply BCD correction and generate carry-out
    always @(temp_sum) begin
        if (temp_sum > 9) begin
            // Apply correction of 6 for sums exceeding 9
            corrected_sum = temp_sum + 6;
            // Generate carry-out
            carry_out = 1;
        end else begin
            // No correction needed, pass the sum as is
            corrected_sum = temp_sum;
            // No carry-out generated
            carry_out = 0;
        end
    end

    // Assign outputs
    assign Sum = corrected_sum;
    assign Cout = carry_out;

endmodule