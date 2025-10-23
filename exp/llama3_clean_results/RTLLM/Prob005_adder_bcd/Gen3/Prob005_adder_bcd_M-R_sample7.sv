module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

reg [3:0] sum_bin;
reg Cout_reg;

always @(*) begin
    // Perform binary addition
    sum_bin = A + B + Cin;
    
    // Generate carry-out
    if (sum_bin > 9) begin
        Cout_reg = 1'b1;
    end else begin
        Cout_reg = 1'b0;
    end
    
    // Apply BCD correction if necessary
    if (sum_bin > 9) begin
        Sum = (sum_bin[3:0] + 4'd6);
    end else begin
        Sum = sum_bin[3:0];
    end
end

assign Cout = Cout_reg;

endmodule