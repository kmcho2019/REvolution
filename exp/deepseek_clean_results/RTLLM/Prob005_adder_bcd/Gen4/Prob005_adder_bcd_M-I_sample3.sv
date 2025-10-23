module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    wire [3:0] binary_sum;
    wire carry_out;
    wire correction_needed;

    // Combined binary addition and carry detection
    assign {carry_out, binary_sum} = A + B + Cin;

    // Optimized correction detection: sum > 9 or carry occurred
    // Equivalent to (binary_sum > 9) | carry_out but using bitwise operations
    assign correction_needed = carry_out | 
                              (binary_sum[3] & (binary_sum[2] | binary_sum[1]));

    // Single adder implementation with conditional correction
    always @(*) begin
        if (correction_needed) begin
            Sum = binary_sum + 4'd6;  // Apply BCD correction
            Cout = 1'b1;              // Set carry out
        end
        else begin
            Sum = binary_sum;         // No correction needed
            Cout = carry_out;         // Pass through original carry
        end
    end

endmodule