module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    // Temporary sum variable to hold the binary sum of A, B, and Cin
    reg [4:0] temp_sum;

    // Perform binary addition
    assign temp_sum = A + B + Cin;

    // Check if the temporary sum exceeds 9 (binary 1001)
    always @(temp_sum) begin
        if (temp_sum > 9) begin
            // If the sum exceeds 9, add 6 to correct it and generate a carry-out
            Sum = (temp_sum + 6)[3:0];  // Corrected sum
            Cout = 1'b1;               // Carry-out generated
        end else begin
            // If the sum does not exceed 9, no correction needed and no carry-out
            Sum = temp_sum[3:0];        // Sum without correction
            Cout = 1'b0;                // No carry-out
        end
    end

endmodule