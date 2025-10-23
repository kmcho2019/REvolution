module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

// Binary sum of A, B, and Cin
wire [4:0] bin_sum = A + B + Cin;

// Apply BCD correction if sum exceeds 9
reg [3:0] corrected_sum;
always @(*) begin
    if (bin_sum > 9) begin
        // Apply correction and set carry-out
        corrected_sum = bin_sum + 6;
        Cout = 1'b1;
    end else begin
        // No correction needed
        corrected_sum = bin_sum[3:0];
        Cout = 1'b0;
    end
end

// Assign corrected sum to output
assign Sum = corrected_sum;

endmodule