module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Directly calculate the binary sum
    wire [4:0] bin_sum = A + B + Cin;

    // Apply BCD correction if the sum exceeds 9 and generate carry-out
    // Explicitly calculate Sum and Cout for clarity and PPA optimization
    always @(*) begin
        if (bin_sum > 9) begin
            Sum = bin_sum[3:0] + 6; // BCD correction
            Cout = 1'b1;             // Generate carry-out
        end else begin
            Sum = bin_sum[3:0];      // Direct sum if no correction needed
            Cout = bin_sum[4];       // Generate carry-out based on MSB of bin_sum
        end
    end

endmodule