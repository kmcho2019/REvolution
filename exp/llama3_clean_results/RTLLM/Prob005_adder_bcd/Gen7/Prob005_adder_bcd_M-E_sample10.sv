module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

reg [3:0] bin_sum;
reg [3:0] corrected_sum;
reg Cout_temp;

always @(*) begin
    bin_sum = A + B + Cin;
    if (bin_sum > 9) begin
        corrected_sum = bin_sum + 4'd6;
        Cout_temp = 1'b1;
    end else begin
        corrected_sum = bin_sum;
        Cout_temp = 1'b0;
    end
end

assign Sum = corrected_sum;
assign Cout = Cout_temp;

endmodule