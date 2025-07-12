module adder_bcd(
    A,  // First BCD input (4-bit)
    B,  // Second BCD input (4-bit)
    Cin, // Carry-in input (1-bit)
    Sum, // 4-bit output representing the sum
    Cout  // Carry-out output (1-bit)
);

input [3:0] A;  // First BCD input (4-bit)
input [3:0] B;  // Second BCD input (4-bit)
input Cin;     // Carry-in input (1-bit)
output [3:0] Sum; // 4-bit output representing the sum
output Cout;     // Carry-out output (1-bit)

reg [3:0] Sum;  // Internal register for the sum
reg Cout;      // Internal register for the carry-out

always @(*) begin
    // Perform binary addition of A, B, and Cin
    reg [4:0] temp_sum;
    temp_sum = {A[3], A[2:0]} + {B[3], B[2:0]} + Cin;

    // Check if the sum exceeds 9 (binary 1001) and apply correction if necessary
    if (temp_sum > 9) begin
        // Add correction of 6 to ensure the sum is within the BCD range
        Sum = temp_sum + 6;
        // Set Cout to 1 since the sum exceeds 9
        Cout = 1'b1;
    end else begin
        // No correction needed, directly assign the sum
        Sum = temp_sum[3:0];
        // Check if the sum before correction exceeds 9 and set Cout accordingly
        if (temp_sum[4]) begin
            Cout = 1'b1;
        end else begin
            Cout = 1'b0;
        end
    end
end

endmodule