module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] binary_sum = A + B + Cin;

    // Correction module using a lookup table (LUT)
    reg [3:0] corrected_sum;
    reg Cout_reg;

    always @(binary_sum) begin
        case (binary_sum)
            5'd0:  begin corrected_sum = 4'd0; Cout_reg = 1'b0; end
            5'd1:  begin corrected_sum = 4'd1; Cout_reg = 1'b0; end
            5'd2:  begin corrected_sum = 4'd2; Cout_reg = 1'b0; end
            5'd3:  begin corrected_sum = 4'd3; Cout_reg = 1'b0; end
            5'd4:  begin corrected_sum = 4'd4; Cout_reg = 1'b0; end
            5'd5:  begin corrected_sum = 4'd5; Cout_reg = 1'b0; end
            5'd6:  begin corrected_sum = 4'd6; Cout_reg = 1'b0; end
            5'd7:  begin corrected_sum = 4'd7; Cout_reg = 1'b0; end
            5'd8:  begin corrected_sum = 4'd8; Cout_reg = 1'b0; end
            5'd9:  begin corrected_sum = 4'd9; Cout_reg = 1'b0; end
            5'd10: begin corrected_sum = 4'd0; Cout_reg = 1'b1; end
            5'd11: begin corrected_sum = 4'd1; Cout_reg = 1'b1; end
            5'd12: begin corrected_sum = 4'd2; Cout_reg = 1'b1; end
            5'd13: begin corrected_sum = 4'd3; Cout_reg = 1'b1; end
            5'd14: begin corrected_sum = 4'd4; Cout_reg = 1'b1; end
            5'd15: begin corrected_sum = 4'd5; Cout_reg = 1'b1; end
            5'd16: begin corrected_sum = 4'd6; Cout_reg = 1'b1; end
            5'd17: begin corrected_sum = 4'd7; Cout_reg = 1'b1; end
            5'd18: begin corrected_sum = 4'd8; Cout_reg = 1'b1; end
            default: begin corrected_sum = 4'd9; Cout_reg = 1'b1; end
        endcase
    end

    // Assign outputs
    assign Sum = corrected_sum;
    assign Cout = Cout_reg;

endmodule