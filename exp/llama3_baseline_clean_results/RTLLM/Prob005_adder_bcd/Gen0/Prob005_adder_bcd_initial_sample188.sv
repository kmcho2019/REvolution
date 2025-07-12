module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    // Temporary sum of A, B, and Cin
    wire [4:0] temp_sum;
    assign temp_sum = {1'b0, A} + {1'b0, B} + {4'b0000, Cin};

    // Check if correction is needed (if sum exceeds 9)
    wire correction_needed;
    assign correction_needed = (temp_sum > 4'd9)? 1'b1 : 1'b0;

    // Apply correction if needed
    reg [4:0] corrected_sum;
    always @(temp_sum, correction_needed) begin
        if (correction_needed) begin
            // Apply correction by adding 6
            corrected_sum = temp_sum + 4'd6;
        end else begin
            // No correction needed, use original sum
            corrected_sum = temp_sum;
        end
    end

    // Assign Sum and Cout
    assign Sum = corrected_sum[3:0];
    assign Cout = (corrected_sum > 4'd9)? 1'b1 : 1'b0;

endmodule