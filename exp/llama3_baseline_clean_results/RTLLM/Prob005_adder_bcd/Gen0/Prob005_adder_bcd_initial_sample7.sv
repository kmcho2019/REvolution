module adder_bcd(
    input [3:0] A,  // First BCD input (4-bit)
    input [3:0] B,  // Second BCD input (4-bit)
    input Cin,     // Carry-in input (1-bit)
    output [3:0] Sum,  // 4-bit output representing the sum of the two BCD inputs
    output Cout      // Carry-out output (1-bit)
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] binary_sum;
    assign binary_sum = {1'b0, A} + {1'b0, B} + {4'b0000, Cin};

    // Check if the sum exceeds 9 and apply BCD correction
    reg [4:0] sum_corrected;
    always @(*) begin
        if (binary_sum > 4'd9) begin
            sum_corrected = binary_sum + 5'd6;
        end else begin
            sum_corrected = binary_sum;
        end
    end

    // Generate carry-out and assign corrected sum to output
    assign Cout = (sum_corrected > 4'd9) ? 1'b1 : 1'b0;
    assign Sum = sum_corrected[3:0];

endmodule