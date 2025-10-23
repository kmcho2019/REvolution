module adder_bcd (
    input  [3:0] A,  // First BCD input
    input  [3:0] B,  // Second BCD input
    input        Cin,  // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the BCD sum
    output       Cout   // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    reg [4:0] temp_sum;
    assign temp_sum = A + B + Cin;

    // Apply BCD correction if sum exceeds 9
    always @(*) begin
        if (temp_sum > 9) begin
            Sum = temp_sum + 6;  // Correction to keep result in BCD range
            Cout = 1'b1;  // Generate carry-out
        end else begin
            Sum = temp_sum[3:0];  // No correction needed, assign sum directly
            Cout = 1'b0;  // No carry-out
        end
    end

endmodule