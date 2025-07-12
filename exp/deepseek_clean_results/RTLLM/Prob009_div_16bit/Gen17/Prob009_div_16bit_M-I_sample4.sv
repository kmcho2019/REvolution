module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [7:0] odd
);

    // Early zero-divisor detection
    wire zero_divisor = (B == 8'b0);
    
    // Carry-save remainder registers
    reg [7:0] rem;
    reg carry;
    
    // Result register
    reg [15:0] res;
    
    always @(*) begin
        if (zero_divisor) begin
            res = 16'b0;
            rem = 8'b0;
            carry = 1'b0;
        end else begin
            // Initialize with MSB
            {carry, rem} = {1'b0, A[15]};
            res[15] = ({carry, rem} >= {1'b0, B});
            
            // Process remaining bits
            for (int i = 14; i >= 0; i = i - 1) begin
                // Shift remainder and add next bit
                {carry, rem} = {rem, A[i]};
                
                // Optimized 8-bit comparison
                if ({carry, rem} >= {1'b0, B}) begin
                    res[i] = 1'b1;
                    {carry, rem} = {carry, rem} - {1'b0, B};
                end else begin
                    res[i] = 1'b0;
                end
            end
        end
    end
    
    assign result = res;
    assign odd = zero_divisor ? 8'b0 : rem;

endmodule