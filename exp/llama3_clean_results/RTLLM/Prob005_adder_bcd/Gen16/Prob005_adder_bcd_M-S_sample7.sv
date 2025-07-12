module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);
    localparam BCD_CORRECTION = 4'd6;
    wire [4:0] bin_sum = {1'b0, A} + {1'b0, B} + {3'b0, Cin};

    assign Cout = (bin_sum > 4'd9) ? 1'b1 : 1'b0;
    assign Sum = (bin_sum > 4'd9) ? (bin_sum[3:0] + BCD_CORRECTION) : bin_sum[3:0];
endmodule