module div_16bit (
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Register inputs
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Division logic
    always @(*) begin
        reg [15:0] dividend;
        reg [7:0]  divisor;
        reg [15:0] quotient;
        reg [7:0]  remainder;
        integer i;

        dividend = a_reg;
        divisor  = b_reg;
        quotient = 16'b0;
        remainder = 8'b0;

        // Process each bit of dividend from MSB to LSB
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring down next dividend bit
            remainder = {remainder[6:0], dividend[i]};
            // Compare remainder with divisor
            if (remainder >= divisor) begin
                remainder = remainder - divisor;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        result = quotient;
        // Place remainder in lower bits of odd, upper bits zeroed
        odd = {8'b0, remainder};
    end

endmodule