module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    reg [4:0] sum_with_carry;
    reg [3:0] temp_sum;
    reg bcd_correction;

    always @(*) begin
        // Perform binary addition of A, B, and Cin
        sum_with_carry = A + B + Cin;

        // Calculate the sum without considering BCD correction
        temp_sum = sum_with_carry[3:0];

        // Check if the sum exceeds 9 and apply BCD correction
        bcd_correction = (sum_with_carry > 4'd9) || (sum_with_carry[4] == 1'b1);

        // Assign Sum and generate Cout
        if (bcd_correction) begin
            Sum = temp_sum + 4'd6;
        end else begin
            Sum = temp_sum;
        end

        Cout = bcd_correction;
    end

endmodule