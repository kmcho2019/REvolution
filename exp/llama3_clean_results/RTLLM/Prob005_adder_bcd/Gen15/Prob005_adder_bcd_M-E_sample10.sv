module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    reg [3:0] sum;
    reg cout;

    always @(*) begin
        reg [4:0] bin_sum;
        bin_sum = {1'b0, A} + {1'b0, B} + {3'b0, Cin};
        
        case (bin_sum)
            5'd0, 5'd1, 5'd2, 5'd3, 5'd4, 5'd5, 5'd6, 5'd7, 5'd8, 5'd9: begin
                sum = bin_sum[3:0];
                cout = 1'b0;
            end
            default: begin
                sum = bin_sum[3:0] + 4'd6;
                cout = 1'b1;
            end
        endcase
    end

    assign Sum = sum;
    assign Cout = cout;

endmodule