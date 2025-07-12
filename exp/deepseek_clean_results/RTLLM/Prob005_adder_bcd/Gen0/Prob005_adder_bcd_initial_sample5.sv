module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    wire [4:0] binary_sum;  // 5-bit to hold sum and carry
    wire need_correction;

    // Perform binary addition of A + B + Cin
    assign binary_sum = A + B + Cin;

    // Check if correction needed (sum > 9 or carry generated)
    assign need_correction = (binary_sum > 9) || (binary_sum[4] == 1'b1);

    always @(*) begin
        if (need_correction) begin
            // Add correction factor 6 and set carry out
            Sum = binary_sum[3:0] + 4'b0110;
            Cout = 1'b1;
        end else begin
            // No correction needed
            Sum = binary_sum[3:0];
            Cout = 1'b0;
        end
    end

endmodule