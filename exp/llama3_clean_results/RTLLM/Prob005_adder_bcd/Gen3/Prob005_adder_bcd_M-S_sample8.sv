module adder_bcd (
    input   [3:0] A,  // First BCD input
    input   [3:0] B,  // Second BCD input
    input       Cin, // Carry-in input
    output reg [3:0] Sum, // 4-bit output representing the sum of the two BCD inputs
    output reg      Cout  // Carry-out output
);

    always @(*) begin
        reg [4:0] bin_sum = A + B + Cin;
        if (bin_sum > 9) begin
            Sum = bin_sum + 6;
            Cout = 1'b1;
        end else begin
            Sum = bin_sum[3:0];
            Cout = bin_sum[4];
        end
    end

endmodule