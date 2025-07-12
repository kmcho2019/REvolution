module adder_bcd (
    input   [3:0] A,  // First BCD input
    input   [3:0] B,  // Second BCD input
    input       Cin, // Carry-in input
    output reg [3:0] Sum, // 4-bit output representing the sum of the two BCD inputs
    output reg      Cout  // Carry-out output
);

    // Temporary variable to hold the binary sum
    reg [4:0] bin_sum;

    // Perform binary addition of A, B, and Cin
    always @(*) begin
        bin_sum = A + B + Cin;
    end

    // LUT-based BCD correction and carry generation
    always @(*) begin
        case (bin_sum)
            5'd0:  {Sum, Cout} = 5'd0;
            5'd1:  {Sum, Cout} = 5'd1;
            5'd2:  {Sum, Cout} = 5'd2;
            5'd3:  {Sum, Cout} = 5'd3;
            5'd4:  {Sum, Cout} = 5'd4;
            5'd5:  {Sum, Cout} = 5'd11; // BCD correction: 5 + 6 = 11
            5'd6:  {Sum, Cout} = 5'd12; // BCD correction: 6 + 6 = 12
            5'd7:  {Sum, Cout} = 5'd13; // BCD correction: 7 + 6 = 13
            5'd8:  {Sum, Cout} = 5'd14; // BCD correction: 8 + 6 = 14
            5'd9:  {Sum, Cout} = 5'd15; // BCD correction: 9 + 6 = 15
            5'd10: {Sum, Cout} = 5'd6;  // BCD correction: 10 + 6 = 16 (6 with carry-out)
            5'd11: {Sum, Cout} = 5'd7;  // BCD correction: 11 + 6 = 17 (7 with carry-out)
            5'd12: {Sum, Cout} = 5'd8;  // BCD correction: 12 + 6 = 18 (8 with carry-out)
            5'd13: {Sum, Cout} = 5'd9;  // BCD correction: 13 + 6 = 19 (9 with carry-out)
            5'd14: {Sum, Cout} = 5'd10; // BCD correction: 14 + 6 = 20 (10 with carry-out)
            5'd15: {Sum, Cout} = 5'd11; // BCD correction: 15 + 6 = 21 (11 with carry-out)
            5'd16: {Sum, Cout} = 5'd12; // BCD correction: 16 + 6 = 22 (12 with carry-out)
            5'd17: {Sum, Cout} = 5'd13; // BCD correction: 17 + 6 = 23 (13 with carry-out)
            5'd18: {Sum, Cout} = 5'd14; // BCD correction: 18 + 6 = 24 (14 with carry-out)
            5'd19: {Sum, Cout} = 5'd15; // BCD correction: 19 + 6 = 25 (15 with carry-out)
            default: {Sum, Cout} = 5'd0; // Default case
        endcase
    end

endmodule