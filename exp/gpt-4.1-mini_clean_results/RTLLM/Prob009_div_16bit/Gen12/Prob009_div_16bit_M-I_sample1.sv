module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder zero-extended to 16 bits
);

    reg [15:0] a_reg;     // Registered dividend
    reg [7:0]  b_reg;     // Registered divisor

    // First always block: register inputs (combinational block)
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second always block: combinational division
    integer i;
    reg [7:0] remainder;   // 8-bit remainder since divisor is 8-bit
    reg [15:0] quotient;

    always @(*) begin
        remainder = 8'd0;
        quotient = 16'd0;

        // Iterate over each bit from MSB to LSB
        for (i = 15; i >= 0; i = i -1) begin
            // Shift left remainder by 1 bit and bring down next dividend bit
            remainder = {remainder[6:0], a_reg[i]};

            // Compare remainder with divisor
            if (remainder >= b_reg) begin
                remainder = remainder - b_reg;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd = {8'd0, remainder}; // zero extend remainder to 16 bits
    end

endmodule