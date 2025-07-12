module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,     // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum
    output Cout      // Carry-out output
);

    reg [4:0] temp_sum;  // Temporary sum to hold the result of binary addition
    reg [3:0] corrected_sum;  // Sum after applying BCD correction

    // Perform binary addition
    assign temp_sum = A + B + Cin;

    // Apply BCD correction if sum exceeds 9
    always @(*) begin
        if (temp_sum > 9) begin
            corrected_sum = temp_sum + 6;
            Cout = 1;  // Generate carry-out if sum exceeds 9
        end else begin
            corrected_sum = temp_sum[3:0];  // Take only the lower 4 bits
            Cout = temp_sum[4];  // Carry-out is the most significant bit
        end
    end

    // Assign the final sum
    assign Sum = corrected_sum;

endmodule