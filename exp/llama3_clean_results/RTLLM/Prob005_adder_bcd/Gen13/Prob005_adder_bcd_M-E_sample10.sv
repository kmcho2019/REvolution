module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Binary sum of A, B, and Cin
    wire [4:0] bin_sum = A + B + Cin;

    // BCD correction LUT
    wire [3:0] corrected_sum;
    always @(*)
    begin
        case (bin_sum)
            5'd0, 5'd1, 5'd2, 5'd3, 5'd4, 5'd5, 5'd6, 5'd7, 5'd8, 5'd9: corrected_sum = bin_sum[3:0];
            5'd10, 5'd11, 5'd12, 5'd13, 5'd14, 5'd15: corrected_sum = bin_sum[3:0] + 4'd6;
            default: corrected_sum = 4'd0; // Handle invalid inputs
        endcase
    end

    // Carry generation
    assign Cout = (bin_sum > 9) || (bin_sum[4] == 1'b1);

    // Assign Sum
    assign Sum = corrected_sum;

endmodule