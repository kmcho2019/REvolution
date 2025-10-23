module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    // Stage 1: Combinational registers for inputs
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Stage 2: Division logic
    always @(*) begin
        integer i;
        reg [8:0] remainder;  // 9-bit remainder to hold intermediate results
        reg [15:0] quotient;

        remainder = 9'd0;
        quotient = 16'd0;

        // Perform division bit-by-bit from MSB to LSB
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift left remainder by 1 and bring down next dividend bit
            remainder = {remainder[7:0], a_reg[i]};
            // Compare remainder with divisor
            if (remainder >= {1'b0, b_reg}) begin
                remainder = remainder - {1'b0, b_reg};
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = {8'd0, remainder[7:0]}; // Zero-extend remainder to 16 bits
    end

endmodule