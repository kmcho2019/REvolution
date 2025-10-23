module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [4:0] sum_binary; // Intermediate sum including carry
    wire [3:0] sum_corrected; // Sum after BCD correction

    // Perform binary addition of A, B, and Cin
    assign sum_binary = {1'b0, A} + {1'b0, B} + {4'b0000, Cin};

    // Check if the sum exceeds 9 (binary 1001) and apply BCD correction
    always @(*) begin
        if (sum_binary > 4'd9) begin
            // Apply correction of 6 (binary 0110)
            sum_corrected = sum_binary[3:0] + 4'd6;
            Cout = 1'b1; // Generate carry-out
        end else begin
            sum_corrected = sum_binary[3:0];
            Cout = sum_binary[4]; // Directly assign carry-out
        end
    end

    // Assign the corrected sum to the output
    assign Sum = sum_corrected;

endmodule