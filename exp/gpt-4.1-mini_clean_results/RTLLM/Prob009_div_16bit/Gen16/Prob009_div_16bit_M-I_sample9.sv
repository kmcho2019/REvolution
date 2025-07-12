module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // First combinational always block: latch inputs to internal registers
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second combinational always block: perform division
    always @(*) begin
        integer i;
        reg [7:0] remainder;
        reg [15:0] quotient_tmp;

        remainder = 8'd0;
        quotient_tmp = 16'd0;

        // Iterate over each bit from MSB to LSB
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring down next dividend bit
            remainder = {remainder[6:0], a_reg[i]};

            // Compare remainder with divisor
            if (remainder >= b_reg) begin
                remainder = remainder - b_reg;
                quotient_tmp[i] = 1'b1;
            end else begin
                quotient_tmp[i] = 1'b0;
            end
        end

        result = quotient_tmp;
        // Zero-extend remainder to 16 bits on output as per specification
        odd = {8'd0, remainder};
    end

endmodule