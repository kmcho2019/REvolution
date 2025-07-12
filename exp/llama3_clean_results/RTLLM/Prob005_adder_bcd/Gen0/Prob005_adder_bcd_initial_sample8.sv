module adder_bcd(
    input   [3:0] A,
    input   [3:0] B,
    input         Cin,
    output  [3:0] Sum,
    output        Cout
);

// Internal wires for sum and carry
wire [4:0] sum_bin;

// Perform binary addition of A, B, and Cin
assign sum_bin = A + B + Cin;

// Generate the final sum and carry-out
always @(A or B or Cin) begin
    if (sum_bin > 9) begin
        // If sum exceeds 9, apply correction and generate carry-out
        Sum = sum_bin + 6;
        Cout = 1'b1;
    end else begin
        // If sum does not exceed 9, no correction needed
        Sum = sum_bin[3:0];
        Cout = 1'b0;
    end
end

endmodule