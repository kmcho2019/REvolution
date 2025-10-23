module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [7:0] odd
);

    reg [8:0] current_remainder;  // 9 bits for comparison (8+1)
    integer i;

    always @(*) begin
        current_remainder = 9'b0;
        result = 16'b0;

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left and bring down next dividend bit
            current_remainder = {current_remainder[7:0], A[i]};
            
            // Non-restoring subtraction approach
            if (current_remainder[8] == 1'b0) begin  // Positive remainder
                current_remainder = current_remainder - {1'b0, B};
                result[i] = 1'b1;
            end
            else begin  // Negative remainder
                current_remainder = current_remainder + {1'b0, B};
                result[i] = 1'b0;
            end
        end

        // Final correction if remainder is negative
        if (current_remainder[8] == 1'b1) begin
            current_remainder = current_remainder + {1'b0, B};
        end

        odd = current_remainder[7:0];  // 8-bit remainder output
    end

endmodule