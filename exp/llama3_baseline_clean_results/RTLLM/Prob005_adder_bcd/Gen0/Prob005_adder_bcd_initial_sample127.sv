module adder_bcd(
    input   [3:0] A,     // First BCD input
    input   [3:0] B,     // Second BCD input
    input         Cin,  // Carry-in input
    output  [3:0] Sum,  // 4-bit output representing the BCD sum
    output        Cout  // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] binary_sum;
    assign binary_sum = {1'b0, A} + {1'b0, B} + {4'b0000, Cin};

    // Check if the sum exceeds 9 (binary 1001) to decide correction and carry-out
    reg [3:0] corrected_sum;
    reg Cout_temp;

    always @(*) begin
        if (binary_sum[4:0] > 4'd9) begin
            corrected_sum = binary_sum[3:0] + 4'd6; // Add correction of 6
            Cout_temp = 1'b1; // Generate carry-out
        end else begin
            corrected_sum = binary_sum[3:0]; // No correction needed
            Cout_temp = 1'b0; // No carry-out
        end
    end

    // Assign outputs
    assign Sum = corrected_sum;
    assign Cout = Cout_temp;

endmodule