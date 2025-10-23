module adder_bcd (
    input   [3:0] A,  // First BCD input
    input   [3:0] B,  // Second BCD input
    input       Cin, // Carry-in input
    output reg [3:0] Sum, // 4-bit output representing the sum of the two BCD inputs
    output reg      Cout  // Carry-out output
);

    // Perform binary addition and apply BCD correction
    always @(*) begin
        reg [4:0] temp_sum = A + B + Cin;
        if (temp_sum > 9) begin
            Sum = (temp_sum + 6)[3:0]; // Apply BCD correction and ensure 4-bit output
            Cout = 1'b1;               // Generate carry-out
        end else begin
            Sum = temp_sum[3:0];      // Direct sum if no correction needed
            Cout = temp_sum[4];       // Generate carry-out based on MSB of sum
        end
    end

endmodule