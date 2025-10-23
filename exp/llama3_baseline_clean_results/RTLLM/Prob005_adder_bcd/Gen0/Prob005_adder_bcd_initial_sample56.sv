module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    reg [4:0] sum_reg; // Register to hold the binary sum
    reg [4:0] corrected_sum; // Register to hold the corrected sum after BCD adjustment

    // Perform binary addition of A, B, and Cin
    always @(A, B, Cin) begin
        sum_reg = (A + B + Cin);
    end

    // Check if the sum exceeds 9, apply correction, and generate carry-out
    always @(sum_reg) begin
        if (sum_reg > 9) begin
            corrected_sum = sum_reg + 6; // Correct the sum by adding 6
            Cout = 1'b1; // Set carry-out to 1
        end else begin
            corrected_sum = sum_reg;
            Cout = 1'b0; // Set carry-out to 0
        end
    end

    // Assign the corrected sum to the output Sum
    always @(corrected_sum) begin
        Sum = corrected_sum[3:0]; // Assign the 4 least significant bits
    end

endmodule