module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    reg [4:0] binary_sum;
    reg [3:0] temp_sum;
    reg Cout_reg;

    always @(*) begin
        // Perform binary addition of A, B, and Cin
        binary_sum = {1'b0, A} + {1'b0, B} + {3'b0, Cin};

        // Check if the sum exceeds 9 (1001 in binary) and generate carry-out accordingly
        Cout_reg = (binary_sum > 5'd9)? 1'b1 : 1'b0;

        // If the sum exceeds 9, add correction of 6 (0110 in binary) to ensure BCD validity
        if (binary_sum > 5'd9) begin
            temp_sum = binary_sum[3:0] + 4'd6;
        end else begin
            temp_sum = binary_sum[3:0];
        end
    end

    assign Sum = temp_sum;
    assign Cout = Cout_reg;

endmodule