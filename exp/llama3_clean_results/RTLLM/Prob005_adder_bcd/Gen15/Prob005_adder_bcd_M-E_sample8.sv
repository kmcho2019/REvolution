module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Stage 1: Binary Sum Computation using a ripple-carry adder
    wire [3:0] bin_sum;
    wire carry_out;
    assign {carry_out, bin_sum} = A + B + Cin;

    // Stage 2: BCD Correction and Carry Generation
    reg [3:0] sum_reg;
    reg cout_reg;

    always @(posedge clk) begin
        if (bin_sum > 4'd9) begin
            // Use a lookup table (LUT) for BCD correction
            // For simplicity, this example uses a direct calculation instead of a LUT
            sum_reg <= bin_sum + 4'd6;
            cout_reg <= 1'b1;
        end else begin
            sum_reg <= bin_sum;
            cout_reg <= 1'b0;
        end
    end

    // Clock-gated BCD correction stage
    assign Sum = (clk == 1'b1 && bin_sum > 4'd9) ? sum_reg : bin_sum;
    assign Cout = (clk == 1'b1 && bin_sum > 4'd9) ? cout_reg : (bin_sum > 4'd9) ? 1'b1 : 1'b0;

endmodule