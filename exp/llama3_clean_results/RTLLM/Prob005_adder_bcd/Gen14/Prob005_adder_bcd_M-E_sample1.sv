module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] binary_sum = A + B + Cin;

    // Use a lookup table or combinational logic to directly generate the corrected BCD sum and carry-out
    // For simplicity, we will use a case statement to mimic the LUT's behavior
    always @(*) begin
        case (binary_sum)
            5'd0, 5'd1, 5'd2, 5'd3, 5'd4, 5'd5, 5'd6, 5'd7, 5'd8, 5'd9: begin
                Sum = binary_sum[3:0];
                Cout = 1'b0;
            end
            5'd10, 5'd11, 5'd12, 5'd13, 5'd14, 5'd15: begin
                Sum = binary_sum[3:0] + 4'd6;
                Cout = 1'b1;
            end
            default: begin
                Sum = binary_sum[3:0] + 4'd6;
                Cout = 1'b1;
            end
        endcase
    end

endmodule