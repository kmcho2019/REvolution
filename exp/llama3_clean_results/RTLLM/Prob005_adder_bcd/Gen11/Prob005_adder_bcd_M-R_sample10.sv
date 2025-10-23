module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    always @(*) begin
        // Perform binary addition of A, B, and Cin
        reg [4:0] sum_with_carry;
        sum_with_carry = A + B + Cin;

        // Assign Sum directly and generate Cout based on the sum exceeding 9 or having a carry
        if (sum_with_carry > 9) begin
            Sum = sum_with_carry[3:0] + 4'd6;
            Cout = 1'b1;
        end else begin
            Sum = sum_with_carry[3:0];
            Cout = sum_with_carry[4];
        end
    end

endmodule