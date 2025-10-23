module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

reg [3:0] sum_reg;
reg Cout_reg;

always @(*) begin
    // Perform binary addition
    wire [4:0] sum_bin = A + B + Cin;
    
    // Check if sum exceeds 9 or if there's a carry from the addition
    Cout_reg = (sum_bin > 9) | (sum_bin[4]);
    
    // Apply BCD correction if necessary
    if (sum_bin > 9) begin
        sum_reg = sum_bin[3:0] + 4'd6;
    end else begin
        sum_reg = sum_bin[3:0];
    end
end

assign Sum = sum_reg;
assign Cout = Cout_reg;

endmodule