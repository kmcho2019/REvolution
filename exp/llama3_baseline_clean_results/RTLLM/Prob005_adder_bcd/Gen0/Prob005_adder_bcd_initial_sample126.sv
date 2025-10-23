module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    // Perform binary addition of A, B, and Cin
    reg [4:0] binary_sum;
    assign binary_sum = (A + B + Cin);

    // Check if the sum exceeds 9
    always @(*) begin
        if (binary_sum > 9) begin
            // Add 6 to the sum and generate a carry-out
            Sum = binary_sum[3:0] + 4'd6;
            Cout = 1'b1;
        end else begin
            // No correction needed
            Sum = binary_sum[3:0];
            Cout = binary_sum[4];
        end
    end

endmodule