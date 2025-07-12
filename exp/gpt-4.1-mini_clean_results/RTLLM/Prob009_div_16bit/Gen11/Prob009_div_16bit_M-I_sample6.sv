module div_16bit (
    input  wire [15:0] A,       // 16-bit dividend
    input  wire [7:0]  B,       // 8-bit divisor
    output reg  [15:0] result,  // 16-bit quotient
    output reg  [15:0] odd      // 16-bit remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // First combinational block: latch inputs into internal registers
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second combinational block: perform division on latched inputs
    always @(*) begin
        integer i;
        reg [8:0] remainder;       // 9-bit remainder
        reg [15:0] quotient;       // 16-bit quotient
        reg [8:0] divisor_ext;     // 9-bit divisor extension

        remainder   = 9'b0;
        quotient    = 16'b0;
        divisor_ext = {1'b0, b_reg};

        for (i = 15; i >= 0; i = i - 1) begin
            remainder = {remainder[7:0], a_reg[i]};
            if (remainder >= divisor_ext) begin
                remainder = remainder - divisor_ext;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        odd    = {8'b0, remainder[7:0]};
    end

endmodule