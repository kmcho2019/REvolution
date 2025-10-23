module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

// Perform binary addition on A, B, and Cin
wire [4:0] sum_binary = A + B + Cin;

// Assign Sum directly from the binary sum if it's within BCD range
// Otherwise, apply the BCD correction
always @(*) begin
    if (sum_binary > 9) begin
        // Apply correction and generate carry-out
        Sum = sum_binary[3:0] + 4'd6;
        Cout = 1'b1;
    end else begin
        // No correction needed, just assign the lower 4 bits of the binary sum
        Sum = sum_binary[3:0];
        Cout = sum_binary[4];
    end
end

endmodule