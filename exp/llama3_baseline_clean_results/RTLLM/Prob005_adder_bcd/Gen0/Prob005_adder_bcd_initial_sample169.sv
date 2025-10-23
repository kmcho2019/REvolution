module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,      // Carry-in
    output [3:0] Sum,  // 4-bit output representing the sum
    output Cout      // Carry-out
);

    // Internal wire to hold the binary sum
    wire [4:0] binary_sum;

    // Perform binary addition of A, B, and Cin
    assign binary_sum = A + B + Cin;

    // Generate the Sum output based on the binary sum
    // If the binary sum exceeds 9, apply BCD correction
    always @(A, B, Cin) begin
        if (binary_sum > 9) begin
            // Apply BCD correction and generate Cout
            Sum = (binary_sum + 6)[3:0];  // Corrected sum
            Cout = 1'b1;  // Carry-out is 1
        end else begin
            // No correction needed
            Sum = binary_sum[3:0];  // Direct assignment of the binary sum
            Cout = binary_sum[4];   // Carry-out from the binary sum
        end
    end

endmodule