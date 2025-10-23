module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

// Perform binary addition of A, B, and Cin
wire [4:0] bin_sum = A + B + Cin;

// Apply BCD correction and generate carry-out
always @(bin_sum) begin
    if (bin_sum > 9) begin // Check if sum exceeds 9
        Sum = bin_sum + 6; // Apply BCD correction
        Cout = 1'b1; // Generate carry-out
    end else begin
        Sum = bin_sum[3:0]; // Assign sum without correction
        Cout = 1'b0; // No carry-out
    end
end

endmodule