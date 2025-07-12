module adder_bcd (
    input  wire [3:0] A,  // First BCD input
    input  wire [3:0] B,  // Second BCD input
    input  wire        Cin,  // Carry-in input
    output reg  [3:0] Sum,  // 4-bit output representing the sum
    output reg         Cout  // Carry-out output
);

// Perform binary addition of A, B, and Cin
reg [4:0] sum_binary;  // Temporary variable to hold the binary sum
always @(*) begin
    sum_binary = A + B + Cin;
    
    // Check if the sum exceeds 9 and apply correction if necessary
    if (sum_binary > 9) begin
        Sum = sum_binary + 6;
        Cout = 1'b1;  // Set carry-out to 1
    end else begin
        Sum = sum_binary[3:0];  // Assign the lower 4 bits of the sum to Sum
        Cout = 1'b0;  // Reset carry-out to 0
    end
end

endmodule