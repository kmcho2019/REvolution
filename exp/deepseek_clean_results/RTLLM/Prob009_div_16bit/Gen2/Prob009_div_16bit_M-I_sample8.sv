module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output reg [15:0] result,
    output reg [15:0] odd
);

    reg [8:0] current_remainder;  // Only need 9 bits for comparison
    reg [15:0] quotient;
    integer i;
    wire [15:0] ext_divisor = {8'b0, B};  // Pre-compute zero-extended divisor

    always @(*) begin
        current_remainder = 9'b0;
        quotient = 16'b0;

        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring down next bit from dividend
            current_remainder = {current_remainder[7:0], A[i]};

            // Compare remainder with divisor
            if (current_remainder >= B) begin
                current_remainder = current_remainder - B;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = {7'b0, current_remainder};  // Zero-extend to 16 bits
    end

endmodule