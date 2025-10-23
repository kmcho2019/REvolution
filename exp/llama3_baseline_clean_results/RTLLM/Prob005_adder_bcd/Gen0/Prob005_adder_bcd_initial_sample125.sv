module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [4:0] binary_sum;
    reg [3:0] corrected_sum;

    // Perform binary addition of A, B, and Cin
    assign binary_sum = {1'b0, A} + {1'b0, B} + {3'b0, Cin};

    // Check if the sum exceeds 9 and apply the correction
    always @(binary_sum) begin
        if (binary_sum > 4'd9) begin
            // Add 6 to correct the sum and generate a carry-out
            corrected_sum = binary_sum[3:0] + 4'd6;
            Cout = 1'b1;
        end else begin
            // No correction needed, just assign the sum
            corrected_sum = binary_sum[3:0];
            Cout = 1'b0;
        end
    end

    // Assign the corrected sum to the output
    assign Sum = corrected_sum;

endmodule