module adder_bcd(
    input  [3:0] A,  // First BCD input
    input  [3:0] B,  // Second BCD input
    input        Cin,  // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum
    output       Cout  // Carry-out output
);

    // Temporary wires for sum and carry
    wire [4:0] bin_sum;

    // Perform binary addition
    assign bin_sum = A + B + Cin;

    // Apply BCD correction and generate carry-out
    always @(A, B, Cin) begin
        if (bin_sum > 9) begin  // If sum exceeds 9, apply correction and generate carry
            Sum = bin_sum + 6;
            Cout = 1'b1;
        end else begin  // Otherwise, no correction needed
            Sum = bin_sum[3:0];
            Cout = 1'b0;
        end
    end

endmodule