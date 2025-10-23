module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

// Temporary sum before BCD correction
wire [4:0] temp_sum;

// Perform binary addition of A, B, and Cin
assign temp_sum = A + B + Cin;

// Perform BCD correction if necessary
always @(temp_sum) begin
    if (temp_sum > 9) begin // If sum exceeds 9, apply correction
        Sum = temp_sum + 6; // Add 6 (0110 in binary) for correction
        Cout = 1; // Generate carry-out
    end
    else begin
        Sum = temp_sum[3:0]; // Assign the sum without correction
        Cout = temp_sum[4]; // Carry-out is the MSB of the temporary sum
    end
end

endmodule