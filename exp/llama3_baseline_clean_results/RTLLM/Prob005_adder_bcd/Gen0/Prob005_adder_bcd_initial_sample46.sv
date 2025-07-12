module adder_bcd (
    input  wire [3:0] A,  // First BCD input
    input  wire [3:0] B,  // Second BCD input
    input  wire       Cin,  // Carry-in input
    output wire [3:0] Sum,  // 4-bit output representing the sum of the two BCD inputs
    output wire       Cout   // Carry-out output
);

    // Perform binary addition
    wire [4:0] binary_sum;
    assign binary_sum = A + B + Cin;

    // Check if the sum exceeds 9 and correct it
    reg [3:0] corrected_sum;
    always @(*) begin
        if (binary_sum > 4'd9) begin
            // Add 6 to correct the sum and set carry-out
            corrected_sum = binary_sum + 4'd6;
            Cout = 1'b1;  // Set carry-out
        end else begin
            // No correction needed, and no carry-out
            corrected_sum = binary_sum[3:0];
            Cout = 1'b0;
        end
    end

    // Assign the corrected sum to the output
    assign Sum = corrected_sum;

endmodule