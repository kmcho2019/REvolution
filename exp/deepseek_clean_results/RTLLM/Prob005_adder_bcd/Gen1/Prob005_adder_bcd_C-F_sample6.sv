module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    wire [4:0] temp_sum;
    wire need_correction;
    
    // First perform binary addition (5-bit to capture carry)
    assign temp_sum = A + B + Cin;
    
    // Optimized correction detection:
    // - temp_sum[4] detects carry from binary addition
    // - (temp_sum[3] & (temp_sum[2] | temp_sum[1])) detects sums 10-15
    assign need_correction = temp_sum[4] || (temp_sum[3] & (temp_sum[2] | temp_sum[1]));
    
    always @(*) begin
        if (need_correction) begin
            {Cout, Sum} = temp_sum + 5'd6;  // Correction adds 6 and sets carry
        end
        else begin
            Cout = 1'b0;
            Sum = temp_sum[3:0];
        end
    end

endmodule