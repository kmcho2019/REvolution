module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    reg [3:0] sum_with_correction;
    reg Cout_temp;

    always @(*) begin
        // Perform binary addition of A, B, and Cin
        reg [4:0] sum_with_carry = A + B + Cin;

        // Check if the sum exceeds 9 and apply BCD correction
        if (sum_with_carry > 9) begin
            sum_with_correction = sum_with_carry[3:0] + 4'd6;
            Cout_temp = 1'b1;
        end else begin
            sum_with_correction = sum_with_carry[3:0];
            Cout_temp = sum_with_carry[4];
        end
    end

    assign Sum = sum_with_correction;
    assign Cout = Cout_temp;

endmodule