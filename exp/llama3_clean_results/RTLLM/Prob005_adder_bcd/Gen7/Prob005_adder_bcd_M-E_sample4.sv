module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Stage 1: Binary Addition
    wire [4:0] binary_sum;
    assign binary_sum = {1'b0, A} + {1'b0, B} + {3'b0, Cin};

    // Stage 2: BCD Correction and Carry Generation
    always @(*) begin
        case (binary_sum)
            5'd0, 5'd1, 5'd2, 5'd3, 5'd4, 5'd5, 5'd6, 5'd7, 5'd8, 5'd9: begin
                Sum = binary_sum[3:0];
                Cout = 1'b0;
            end
            default: begin
                Sum = (binary_sum + 5'd6)[3:0];
                Cout = 1'b1;
            end
        endcase
    end

endmodule