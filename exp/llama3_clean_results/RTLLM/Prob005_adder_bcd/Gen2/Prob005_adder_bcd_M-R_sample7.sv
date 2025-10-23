module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    reg [3:0] sum_reg;
    reg cout_reg;

    always @(*) begin
        // Perform binary addition of A, B, and Cin
        reg [4:0] binary_sum;
        binary_sum = {1'b0, A} + {1'b0, B} + {3'b0, Cin};

        // Check if the sum exceeds 9 (1001 in binary) and generate carry-out accordingly
        cout_reg = (binary_sum > 5'd9)? 1'b1 : 1'b0;

        // If the sum exceeds 9, add correction of 6 (0110 in binary) to ensure BCD validity
        reg [4:0] temp_sum;
        temp_sum = (binary_sum > 5'd9)? binary_sum + 5'd6 : binary_sum;

        // Assign the corrected sum to the output
        sum_reg = temp_sum[3:0];
    end

    assign Sum = sum_reg;
    assign Cout = cout_reg;

endmodule