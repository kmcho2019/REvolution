module div_16bit (
    input  wire [15:0] A,      // 16-bit dividend
    input  wire [7:0]  B,      // 8-bit divisor
    output reg  [15:0] result, // 16-bit quotient
    output reg  [15:0] odd     // 16-bit remainder (zero-extended)
);

    // Combinational division logic
    always @(*) begin
        reg [7:0] remainder;
        reg [15:0] quotient;
        integer i;

        remainder = 8'd0;
        quotient = 16'd0;

        // Iterate from MSB to LSB of dividend A
        for (i = 15; i >= 0; i = i -1) begin
            // Shift remainder left by 1 and bring down the current dividend bit
            remainder = {remainder[6:0], A[i]};

            // Compare remainder with divisor
            if (remainder >= B) begin
                remainder = remainder - B;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = {8'b0, remainder};  // zero-extend remainder to 16 bits
    end

endmodule