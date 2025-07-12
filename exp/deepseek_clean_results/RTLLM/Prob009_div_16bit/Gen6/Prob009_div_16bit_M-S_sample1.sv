module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [7:0] current_remainder;
    integer i;

    always @(*) begin
        current_remainder = 8'b0;
        result = 16'b0;

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring down next bit from dividend
            current_remainder = {current_remainder[6:0], A[i]};

            // Compare remainder with divisor
            if (current_remainder >= B) begin
                current_remainder = current_remainder - B;
                result[i] = 1'b1;
            end
            // else: result[i] remains 0 (default)
        end

        odd = {8'b0, current_remainder};  // Zero-extend to 16 bits
    end

endmodule