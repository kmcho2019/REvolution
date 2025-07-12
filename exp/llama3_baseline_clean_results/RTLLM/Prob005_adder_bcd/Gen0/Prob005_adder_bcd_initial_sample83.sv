module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input       Cin,
    output [3:0] Sum,
    output      Cout
);

    // Internal signal to hold the binary sum
    wire [4:0] binary_sum;

    // Perform binary addition of A, B, and Cin
    assign binary_sum = {1'b0, A} + {1'b0, B} + {4'b0000, Cin};

    // Determine if BCD correction is needed
    reg [3:0] corrected_sum;
    reg       apply_correction;

    always @(*) begin
        // Apply BCD correction if the binary sum exceeds 9
        if (binary_sum > 4'd9) begin
            corrected_sum = binary_sum[3:0] + 4'd6;
            apply_correction = 1'b1;
        end else begin
            corrected_sum = binary_sum[3:0];
            apply_correction = 1'b0;
        end
    end

    // Assign the final sum and carry-out
    assign Sum = corrected_sum;
    assign Cout = (binary_sum[4] | (apply_correction && (corrected_sum > 4'd9)));

endmodule