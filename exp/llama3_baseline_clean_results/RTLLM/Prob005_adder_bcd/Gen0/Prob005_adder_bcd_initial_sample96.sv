module adder_bcd(
    input   [3:0] A,  // First BCD input (4-bit)
    input   [3:0] B,  // Second BCD input (4-bit)
    input         Cin,  // Carry-in input (1-bit)
    output  [3:0] Sum,  // 4-bit output representing the sum of the two BCD inputs
    output        Cout  // Carry-out output (1-bit)
);

    // Perform binary addition of A, B, and Cin
    reg [4:0] sum_temp;
    assign sum_temp = A + B + Cin;

    // Check if the sum exceeds 9 and apply BCD correction if necessary
    always @(A, B, Cin) begin
        if (sum_temp > 9) begin
            Sum = sum_temp + 6;
            Cout = 1;
        end else begin
            Sum = sum_temp[3:0];
            Cout = 0;
        end
    end

endmodule