module adder_bcd(
    input [3:0] A, 
    input [3:0] B, 
    input Cin, 
    output [3:0] Sum, 
    output Cout
);

// Internal wires to hold the binary sum and carry
wire [4:0] bin_sum;

// Perform binary addition of A, B, and Cin
assign bin_sum = A + B + Cin;

// Check if the binary sum exceeds 9 (1001 in binary)
// If it does, add 6 (0110 in binary) to correct the sum and set Cout
// Otherwise, simply assign the sum and Cout
always @(*)
begin
    if (bin_sum > 9) 
    begin
        Sum = bin_sum + 6;
        Cout = 1'b1;
    end
    else 
    begin
        Sum = bin_sum[3:0]; // Only take the lower 4 bits of the binary sum
        Cout = bin_sum[4];  // The carry-out is the most significant bit of the binary sum
    end
end

endmodule