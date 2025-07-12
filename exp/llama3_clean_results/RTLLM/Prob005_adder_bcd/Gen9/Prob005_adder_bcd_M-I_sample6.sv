module adder_bcd (
    input   [3:0] A,  // First BCD input
    input   [3:0] B,  // Second BCD input
    input       Cin, // Carry-in input
    output reg [3:0] Sum, // 4-bit output representing the sum of the two BCD inputs
    output reg      Cout  // Carry-out output
);

    // Perform binary addition
    reg [4:0] bin_sum;
    always @(*) begin
        bin_sum = A + B + Cin;
    end

    // Simplified BCD correction and carry-out generation
    always @(*) begin
        if (bin_sum > 9) begin
            Sum = bin_sum[3:0] + 6; // Directly calculate corrected sum
            Cout = 1'b1;             // Generate carry-out
        end else begin
            Sum = bin_sum[3:0];      // Direct sum if no correction needed
            Cout = bin_sum[4];       // Generate carry-out based on MSB of bin_sum
        end
    end

endmodule