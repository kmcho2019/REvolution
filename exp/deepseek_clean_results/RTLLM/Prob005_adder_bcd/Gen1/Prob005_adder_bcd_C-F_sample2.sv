module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

    reg [4:0] temp_sum;
    reg correction_needed;
    
    always @(*) begin
        // Perform binary addition
        temp_sum = A + B + Cin;
        
        // Check if correction is needed (sum > 9 or carry generated)
        // Bit pattern: sum[4] OR (sum[3] AND (sum[2] OR sum[1]))
        correction_needed = temp_sum[4] | (temp_sum[3] & (temp_sum[2] | temp_sum[1]));
        
        // Apply correction if needed
        if (correction_needed) begin
            {Cout, Sum} = temp_sum + 5'b00110; // Add 6 with carry handling
        end
        else begin
            Cout = 1'b0;
            Sum = temp_sum[3:0];
        end
    end

endmodule