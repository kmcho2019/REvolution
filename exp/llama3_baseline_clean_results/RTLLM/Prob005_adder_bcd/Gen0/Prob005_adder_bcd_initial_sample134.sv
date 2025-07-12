module adder_bcd (
    input [3:0] A, // First BCD input
    input [3:0] B, // Second BCD input
    input Cin,    // Carry-in input
    output [3:0] Sum, // 4-bit output representing the sum of the two BCD inputs
    output Cout    // Carry-out output
);

// Perform binary addition of A, B, and Cin
wire [4:0] binary_sum;
assign binary_sum = {1'b0, A} + {1'b0, B} + {3'b0, Cin};

// Generate the sum within the BCD range
reg [3:0] temp_sum;
always @(*)
begin
    if (binary_sum > 9) // If sum exceeds 9, add correction
    begin
        temp_sum = binary_sum[3:0] + 4'd6;
        Cout = 1'b1; // Generate carry-out
    end
    else
    begin
        temp_sum = binary_sum[3:0];
        Cout = binary_sum[4]; // Directly assign carry-out from binary sum
    end
end

// Output the corrected sum
assign Sum = temp_sum;

endmodule