module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [4:0] bin_sum;
    reg [3:0] sum_reg;
    reg Cout_reg;

    always @(*)
    begin
        bin_sum = {1'b0, A} + {1'b0, B} + {3'b0, Cin};
        
        if (bin_sum > 4'd9)
        begin
            sum_reg = bin_sum[3:0] + 4'd6;
            Cout_reg = 1'b1;
        end
        else
        begin
            sum_reg = bin_sum[3:0];
            Cout_reg = 1'b0;
        end
    end

    assign Sum = sum_reg;
    assign Cout = Cout_reg;

endmodule