module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

// Perform binary addition
wire [4:0] binary_sum = A + B + Cin;

// Use a lookup table to determine the corrected BCD sum and carry-out
always @(*) begin
    case (binary_sum)
        4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9: begin
            Sum = binary_sum[3:0];
            Cout = 1'b0;
        end
        4'd10, 4'd11, 4'd12, 4'd13, 4'd14, 4'd15: begin
            Sum = binary_sum[3:0] + 4'd6;
            Cout = 1'b1;
        end
        default: begin
            Sum = 4'd0;
            Cout = 1'b0;
        end
    endcase
end

endmodule