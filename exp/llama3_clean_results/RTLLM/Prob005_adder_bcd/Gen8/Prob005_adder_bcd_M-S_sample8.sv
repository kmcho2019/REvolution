module adder_bcd (
    input   [3:0] A,  // First BCD input
    input   [3:0] B,  // Second BCD input
    input       Cin, // Carry-in input
    output reg [3:0] Sum, // 4-bit output representing the sum of the two BCD inputs
    output reg      Cout  // Carry-out output
);

    always @(*) begin
        // Perform binary addition directly
        if (A + B + Cin > 9) begin
            Sum = (A + B + Cin + 6)[3:0]; // BCD correction
            Cout = 1'b1;                   // Generate carry-out
        end else begin
            Sum = A + B + Cin;            // Direct sum if no correction needed
            Cout = (A + B + Cin > 9) ? 1'b1 : 1'b0; // Corrected carry-out generation
        end
    end

endmodule