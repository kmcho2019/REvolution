module adder_bcd(
    A,  // First BCD input (4-bit)
    B,  // Second BCD input (4-bit)
    Cin,  // Carry-in input (1-bit)
    Sum,  // 4-bit output representing the sum of the two BCD inputs
    Cout  // Carry-out output (1-bit)
);

// Input ports
input [3:0] A;
input [3:0] B;
input Cin;

// Output ports
output [3:0] Sum;
output Cout;

// Internal wires
wire [4:0] binary_sum;
reg [3:0] corrected_sum;

// Perform binary addition of A, B, and Cin
assign binary_sum = {1'b0, A} + {1'b0, B} + {4'b0000, Cin};

// Generate carry-out (Cout)
assign Cout = (binary_sum > 4'd9) ? 1'b1 : 1'b0;

// Perform BCD correction if the sum exceeds 9
always @(binary_sum) begin
    if (binary_sum > 4'd9) begin
        corrected_sum = binary_sum + 4'd6;
    end else begin
        corrected_sum = binary_sum[3:0];
    end
end

// Assign the corrected sum to the output Sum
assign Sum = corrected_sum;

endmodule