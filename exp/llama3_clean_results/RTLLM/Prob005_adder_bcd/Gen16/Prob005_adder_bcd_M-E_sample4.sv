module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);
    reg [4:0] sum_reg;
    wire [4:0] sum;
    reg [3:0] corrected_sum;
    reg Cout_reg;

    // Binary addition stage
    always @(*) begin
        sum = A + B + Cin;
    end

    // Pipeline register
    always @(posedge clk) begin
        sum_reg <= sum;
    end

    // BCD correction stage
    always @(*) begin
        if (sum_reg > 9) begin
            corrected_sum = sum_reg[3:0] + 6;
            Cout_reg = 1'b1;
        end else begin
            corrected_sum = sum_reg[3:0];
            Cout_reg = 1'b0;
        end
    end

    // Output assignments
    assign Sum = corrected_sum;
    assign Cout = Cout_reg;
endmodule