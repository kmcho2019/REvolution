module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    wire [3:0] temp_sum;
    wire carry_out;
    wire need_correction;
    
    // 4-bit addition with carry out
    assign {carry_out, temp_sum} = A + B + Cin;
    
    // Detect if sum >9 using bit pattern (1001)
    assign need_correction = carry_out | (temp_sum[3] & (temp_sum[2] | temp_sum[1]));
    
    always @(*) begin
        if (need_correction) begin
            {Cout, Sum} = {1'b1, temp_sum} + 6;
        end
        else begin
            Cout = carry_out;
            Sum = temp_sum;
        end
    end

endmodule