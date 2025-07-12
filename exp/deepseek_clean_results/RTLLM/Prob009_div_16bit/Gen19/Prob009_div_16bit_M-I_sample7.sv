module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    always @(*) begin
        reg [8:0] acc = 0;  // 9-bit accumulator (8+1 for comparison)
        reg [15:0] quotient = 0;
        reg [7:0] divisor = B;
        
        // Handle zero-divisor case immediately
        if (divisor == 8'b0) begin
            quotient = 16'b0;
            acc = 9'b0;
        end
        else begin
            // Process each bit sequentially
            for (int i = 15; i >= 0; i = i - 1) begin
                // Shift accumulator left and bring in next bit
                acc = {acc[7:0], A[i]};
                
                // Carry-save subtraction and comparison
                if (acc >= {1'b0, divisor}) begin
                    quotient[i] = 1'b1;
                    acc = acc - {1'b0, divisor};
                end
                else begin
                    quotient[i] = 1'b0;
                end
            end
        end
        
        // Assign outputs
        result = quotient;
        odd = {8'b0, acc[7:0]};
    end

endmodule