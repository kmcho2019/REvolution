module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Early zero-divisor detection
    wire zero_divisor = (B == 8'b0);
    
    // Carry-save remainder registers
    reg [7:0] rem_carry;
    reg [7:0] rem_sum;
    
    // Result registers
    reg [15:0] quotient;
    
    // Combinational logic for all bits
    always @(*) begin
        if (zero_divisor) begin
            quotient = 16'b0;
            rem_carry = 8'b0;
            rem_sum = 8'b0;
        end else begin
            // Initialize with MSB of dividend
            rem_carry = 8'b0;
            rem_sum = {7'b0, A[15]};
            
            // Process each bit
            for (int i = 15; i >= 0; i = i - 1) begin
                // Carry-save addition of current remainder and next bit
                wire [7:0] next_rem = {rem_sum[6:0], (i > 0) ? A[i-1] : 1'b0};
                
                // Combined remainder (sum + carry)
                wire [8:0] full_rem = {1'b0, next_rem} + {1'b0, rem_carry};
                
                // Comparison and subtraction
                if (full_rem >= {1'b0, B}) begin
                    quotient[i] = 1'b1;
                    {rem_carry, rem_sum} = full_rem - {1'b0, B};
                end else begin
                    quotient[i] = 1'b0;
                    rem_carry = 8'b0;
                    rem_sum = next_rem;
                end
            end
        end
    end
    
    // Output assignments
    assign result = quotient;
    assign odd = zero_divisor ? 8'b0 : rem_sum;

endmodule