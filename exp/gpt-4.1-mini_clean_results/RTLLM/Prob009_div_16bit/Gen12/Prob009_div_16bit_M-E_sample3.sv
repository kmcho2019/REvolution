module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Capture inputs into internal registers
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Perform combinational division calculation
    always @(*) begin
        integer i;
        reg [7:0] divisor;
        reg [15:0] quotient_tmp;
        reg [15:0] remainder_tmp; // Holds remainder shifted with dividend bits

        divisor = b_reg;
        quotient_tmp = 16'b0;
        remainder_tmp = 16'b0;

        // Process each bit of dividend from MSB to LSB
        for (i = 15; i >= 0; i = i -1) begin
            // Shift left remainder by 1 and bring down next dividend bit
            remainder_tmp = {remainder_tmp[14:0], a_reg[i]};

            // Compare remainder with divisor (divisor zero check avoided by user)
            if (remainder_tmp[15:8] >= divisor) begin
                remainder_tmp[15:8] = remainder_tmp[15:8] - divisor;
                quotient_tmp[i] = 1'b1;
            end else begin
                quotient_tmp[i] = 1'b0;
            end
        end

        result = quotient_tmp;
        // Remainder stored in upper 8 bits of remainder_tmp, assign to odd lower 8 bits and clear upper bits
        odd = {8'b0, remainder_tmp[15:8]};
    end

endmodule