module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [4:0] bin_sum;  // Binary sum of A, B, and Cin
    reg [3:0] corrected_sum;  // Corrected sum after BCD adjustment
    reg Cout_reg;  // Register for carry-out

    // Perform binary addition of A, B, and Cin
    assign bin_sum = A + B + Cin;

    // Check if binary sum exceeds 9 (1001 in binary) and apply correction
    always @(bin_sum) begin
        if (bin_sum > 4'd9) begin
            // Apply correction by adding 6 to the sum
            corrected_sum = bin_sum[3:0] + 4'd6;
            Cout_reg = 1'b1;  // Set carry-out to 1
        end else begin
            corrected_sum = bin_sum[3:0];
            Cout_reg = 1'b0;  // Set carry-out to 0
        end
    end

    // Assign outputs
    assign Sum = corrected_sum;
    assign Cout = Cout_reg;

endmodule