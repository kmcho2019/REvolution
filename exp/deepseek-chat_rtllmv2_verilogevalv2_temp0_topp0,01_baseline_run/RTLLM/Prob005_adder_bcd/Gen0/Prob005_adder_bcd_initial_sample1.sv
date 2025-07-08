module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    wire [4:0] binary_sum;
    wire need_correction;

    // Perform binary addition of A, B, and Cin
    assign binary_sum = A + B + Cin;

    // Check if correction is needed (sum > 9 or carry generated)
    assign need_correction = (binary_sum > 9) | (binary_sum[4] == 1'b1);

    // Apply BCD correction if needed
    always @(*) begin
        if (need_correction) begin
            Sum = binary_sum[3:0] + 6;  // Add correction factor
            Cout = 1'b1;                // Set carry out
        end
        else begin
            Sum = binary_sum[3:0];      // No correction needed
            Cout = 1'b0;                // No carry out
        end
    end

endmodule