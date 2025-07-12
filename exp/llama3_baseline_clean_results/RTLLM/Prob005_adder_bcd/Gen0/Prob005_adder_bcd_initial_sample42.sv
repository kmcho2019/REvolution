module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Internal signal to hold the initial binary sum
    wire [4:0] binary_sum;

    // Perform binary addition of A, B, and Cin
    assign binary_sum = {1'b0, A} + {1'b0, B} + {4'b0000, Cin};

    // Conditional statement to apply BCD correction and generate carry-out
    always @(binary_sum) begin
        if (binary_sum >= 10) begin
            // Apply BCD correction and generate carry-out
            Sum = binary_sum[3:0] + 4'b0110;
            Cout = 1'b1;
        end else begin
            // No correction needed, assign the binary sum to the output
            Sum = binary_sum[3:0];
            Cout = binary_sum[4];
        end
    end

endmodule