module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

// Internal signal to hold the initial binary sum
reg [4:0] sum_temp;

// Perform binary addition of A, B, and Cin
always @(A, B, Cin) begin
    sum_temp = A + B + Cin;
    
    // Check if the sum exceeds 9 and correct it if necessary
    if (sum_temp > 9) begin
        // Add 6 to correct the sum and generate a carry-out
        Sum = sum_temp + 6;
        // Since the sum exceeds 9, a carry-out is generated
        Cout = 1'b1;
    end else begin
        // If the sum is within the BCD range, no correction needed
        Sum = sum_temp[3:0]; // Only take the lower 4 bits
        // No carry-out generated
        Cout = 1'b0;
    end
end

endmodule