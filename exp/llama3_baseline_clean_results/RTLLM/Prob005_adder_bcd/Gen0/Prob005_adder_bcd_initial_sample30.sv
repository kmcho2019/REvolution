module adder_bcd(
    input  [3:0] A,  // First BCD input
    input  [3:0] B,  // Second BCD input
    input        Cin,  // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum
    output       Cout   // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] bin_sum = A + B + Cin;
    
    // Check if the sum exceeds 9 (binary 1001)
    assign Cout = (bin_sum > 9)? 1'b1 : 1'b0;
    
    // If the sum exceeds 9, add a correction of 6 (binary 0110) to the sum
    reg [4:0] corrected_sum;
    always @(A, B, Cin) begin
        if (bin_sum > 9) begin
            corrected_sum = bin_sum + 6;
        end else begin
            corrected_sum = bin_sum;
        end
    end
    
    // Assign the corrected sum to the output Sum, taking only the lower 4 bits
    assign Sum = corrected_sum[3:0];

endmodule