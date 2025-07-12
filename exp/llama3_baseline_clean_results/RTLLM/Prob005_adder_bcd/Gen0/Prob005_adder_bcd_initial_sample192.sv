module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    reg [4:0] sum_temp;
    always @(A, B, Cin) begin
        sum_temp = A + B + Cin;
    end

    // Apply BCD correction if sum exceeds 9
    always @(sum_temp) begin
        if (sum_temp > 9) begin
            Sum = sum_temp + 6;
            Cout = 1'b1;
        end else begin
            Sum = sum_temp[3:0];
            Cout = 1'b0;
        end
    end

endmodule