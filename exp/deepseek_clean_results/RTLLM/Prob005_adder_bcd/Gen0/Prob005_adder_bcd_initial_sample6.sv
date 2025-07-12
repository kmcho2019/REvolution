module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    wire [4:0] temp_sum;
    wire need_correction;
    
    // First perform binary addition
    assign temp_sum = A + B + Cin;
    
    // Check if correction is needed (sum > 9)
    assign need_correction = (temp_sum > 9) || (temp_sum[4] == 1'b1);
    
    always @(*) begin
        if (need_correction) begin
            // Add 6 and set carry out
            {Cout, Sum} = temp_sum + 6;
        end
        else begin
            // No correction needed
            Cout = 1'b0;
            Sum = temp_sum[3:0];
        end
    end

endmodule