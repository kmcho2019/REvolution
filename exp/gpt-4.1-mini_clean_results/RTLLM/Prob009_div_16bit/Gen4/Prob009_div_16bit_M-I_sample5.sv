module div_16bit (
    input  wire [15:0] A,      // 16-bit dividend
    input  wire [7:0]  B,      // 8-bit divisor
    output reg  [15:0] result, // 16-bit quotient
    output reg  [15:0] odd     // 16-bit remainder
);

    reg [15:0] quotient;
    reg [15:0] remainder;
    reg [15:0] temp_dividend;
    reg [7:0]  extracted;
    integer i;

    always @(*) begin
        quotient     = 16'd0;
        remainder    = 16'd0;
        temp_dividend = A;

        // Perform division using iterative extraction of 8-bit chunks from the top of temp_dividend
        // Each iteration sets one quotient bit and updates remainder and temp_dividend accordingly
        for (i = 15; i >= 0; i = i - 1) begin
            // Extract the top 8 bits of temp_dividend
            extracted = temp_dividend[15:8];

            if (extracted >= B) begin
                quotient[i] = 1'b1;
                // remainder upper 8 bits = extracted - B
                remainder[15:8] = extracted - B;
            end else begin
                quotient[i] = 1'b0;
                remainder[15:8] = extracted;
            end

            // Concatenate remainder (bits 15:8) with next highest dividend bit (bit 7 of temp_dividend)
            // Shift remainder left by 1 bit, insert temp_dividend[7] at LSB of remainder[8]
            remainder = {remainder[14:8], temp_dividend[7], remainder[7:0]};

            // Shift temp_dividend left by 1 to drop the processed bit and bring in next bit
            temp_dividend = {temp_dividend[14:0], 1'b0};
        end

        result = quotient;
        odd    = remainder;
    end

endmodule