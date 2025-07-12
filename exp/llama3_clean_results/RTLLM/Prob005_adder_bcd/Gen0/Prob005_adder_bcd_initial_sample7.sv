module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input       Cin,
    output [3:0] Sum,
    output      Cout
);

    // Declare a temporary sum variable to hold the binary sum of A, B, and Cin
    reg [4:0] temp_sum;

    // Perform binary addition of A, B, and Cin
    always @(A or B or Cin) begin
        temp_sum = A + B + Cin;

        // Apply BCD correction if the sum exceeds 9
        if (temp_sum > 9) begin
            Sum = temp_sum + 6;
            Cout = 1'b1;  // Generate carry-out
        end else begin
            Sum = temp_sum[3:0];  // Take only the lower 4 bits
            Cout = 1'b0;  // No carry-out
        end
    end

endmodule