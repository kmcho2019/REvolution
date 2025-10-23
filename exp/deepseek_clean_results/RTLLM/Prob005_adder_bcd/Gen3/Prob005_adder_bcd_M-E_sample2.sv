module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    wire [4:0] total = A + B + Cin;  // 5-bit to handle overflow (max 9+9+1=19)

    // LUT implementation for BCD correction
    always @(*) begin
        case (total)
            5'd0:  begin Sum = 4'd0; Cout = 1'b0; end
            5'd1:  begin Sum = 4'd1; Cout = 1'b0; end
            5'd2:  begin Sum = 4'd2; Cout = 1'b0; end
            5'd3:  begin Sum = 4'd3; Cout = 1'b0; end
            5'd4:  begin Sum = 4'd4; Cout = 1'b0; end
            5'd5:  begin Sum = 4'd5; Cout = 1'b0; end
            5'd6:  begin Sum = 4'd6; Cout = 1'b0; end
            5'd7:  begin Sum = 4'd7; Cout = 1'b0; end
            5'd8:  begin Sum = 4'd8; Cout = 1'b0; end
            5'd9:  begin Sum = 4'd9; Cout = 1'b0; end
            5'd10: begin Sum = 4'd0; Cout = 1'b1; end
            5'd11: begin Sum = 4'd1; Cout = 1'b1; end
            5'd12: begin Sum = 4'd2; Cout = 1'b1; end
            5'd13: begin Sum = 4'd3; Cout = 1'b1; end
            5'd14: begin Sum = 4'd4; Cout = 1'b1; end
            5'd15: begin Sum = 4'd5; Cout = 1'b1; end
            5'd16: begin Sum = 4'd6; Cout = 1'b1; end
            5'd17: begin Sum = 4'd7; Cout = 1'b1; end
            5'd18: begin Sum = 4'd8; Cout = 1'b1; end
            5'd19: begin Sum = 4'd9; Cout = 1'b1; end
            default: begin Sum = 4'd0; Cout = 1'b0; end
        endcase
    end

endmodule