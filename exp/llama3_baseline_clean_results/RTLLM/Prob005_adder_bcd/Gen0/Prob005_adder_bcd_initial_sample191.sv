module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Temporary variables to hold the sum before correction and the carry
    reg [4:0] temp_sum;
    reg Cout_temp;

    // Perform binary addition of A, B, and Cin
    assign temp_sum = A + B + Cin;

    // Generate carry-out based on whether the sum exceeds 9 (binary 1001)
    assign Cout_temp = (temp_sum > 4'd9) ? 1'b1 : 1'b0;

    // Apply BCD correction if sum exceeds 9
    always @(*)
    begin
        if (temp_sum > 4'd9)
        begin
            // Apply correction by adding 6 (binary 0110) to the sum
            Sum = (temp_sum + 4'd6) % 10;
        end
        else
        begin
            Sum = temp_sum[3:0]; // Directly assign the sum without correction
        end
    end

    // Assign the carry-out
    assign Cout = Cout_temp;

endmodule