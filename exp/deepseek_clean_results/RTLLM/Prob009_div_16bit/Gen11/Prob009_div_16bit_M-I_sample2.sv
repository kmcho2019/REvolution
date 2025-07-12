module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [7:0] odd
);

    reg [8:0] current_remainder;
    integer i;

    always @(*) begin
        current_remainder = 9'b0;
        
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift in next dividend bit
            current_remainder = {current_remainder[7:0], A[i]};
            
            // Comparison and subtraction
            if (current_remainder >= {1'b0, B}) begin
                current_remainder = current_remainder - {1'b0, B};
                result[i] = 1'b1;
            end else begin
                result[i] = 1'b0;
            end
        end

        // Final remainder (only need 8 bits)
        odd = current_remainder[7:0];
    end

endmodule