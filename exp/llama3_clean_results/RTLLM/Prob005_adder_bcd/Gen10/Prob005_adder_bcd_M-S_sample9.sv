module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    reg [4:0] sum_with_carry;

    always @(A or B or Cin) begin
        sum_with_carry = A + B + Cin;
        
        // Apply BCD correction if sum exceeds 9
        if (sum_with_carry > 9) begin
            Sum = sum_with_carry[3:0] + 4'd6;
            Cout = 1'b1;
        end else begin
            Sum = sum_with_carry[3:0];
            Cout = sum_with_carry[4];
        end
    end

endmodule