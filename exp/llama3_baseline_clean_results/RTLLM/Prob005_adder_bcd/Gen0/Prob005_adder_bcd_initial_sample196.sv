module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

// Perform binary addition of A, B, and Cin
reg [4:0] sum_bin;

always @(A or B or Cin) begin
    sum_bin = A + B + Cin;
    
    // If sum exceeds 9 (1001 in binary), add 6 (0110) for BCD correction and set Cout
    if (sum_bin > 9) begin
        Sum = sum_bin + 6;
        Cout = 1'b1;
    end else begin
        Sum = sum_bin[3:0]; // Assign the lower 4 bits of sum_bin to Sum
        Cout = 1'b0;
    end
end

endmodule