module div_16bit(
    input  wire [15:0] A,        // 16-bit dividend
    input  wire [7:0]  B,        // 8-bit divisor
    output reg  [15:0] result,   // 16-bit quotient
    output reg  [15:0] odd       // 16-bit remainder (lower 8 bits valid)
);

    // Internal registers to hold latched inputs
    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Latch inputs combinationally to stabilize signals during division calculation
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Combinational division logic: restoring division method
    always @(*) begin
        integer i;
        reg [8:0] remainder;        // 9-bit remainder to hold carry out in subtraction
        reg [15:0] quotient;        // 16-bit quotient register
        reg [8:0] divisor_ext;      // Divisor extended to 9 bits for subtraction

        remainder    = 9'd0;
        quotient     = 16'd0;
        divisor_ext  = {1'b0, b_reg};

        // Iterate from MSB to LSB
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring down the current dividend bit
            remainder = {remainder[7:0], a_reg[i]};
            // Compare remainder with divisor
            if (remainder >= divisor_ext) begin
                remainder = remainder - divisor_ext;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        // Zero-extend 8-bit remainder into 16-bit odd output
        odd = {8'd0, remainder[7:0]};
    end

endmodule