module div_16bit (
    input  wire [15:0] A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg  [15:0] odd
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Always block 1: update registers with inputs
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Always block 2: perform division as per specified algorithm
    always @(*) begin
        reg [7:0] remainder;       // 8-bit remainder, matches divisor width
        reg [15:0] quotient;       // 16-bit quotient
        integer i;

        // Default outputs
        quotient = 16'd0;
        remainder = 8'd0;

        if (b_reg == 8'd0) begin
            // Division by zero: zero quotient and remainder
            quotient = 16'd0;
            remainder = 8'd0;
        end else begin
            // Initialize remainder with the highest 8 bits of dividend
            remainder = a_reg[15:8];

            // Process each bit from MSB to LSB
            // For bit position i (from 15 down to 0), do:
            // 1. Compare remainder with divisor.
            // 2. If remainder >= divisor: set quotient bit i = 1, remainder = remainder - divisor.
            //    else quotient bit i = 0.
            // 3. Shift remainder left by 1 and bring in next dividend bit (a_reg[i-1]), except for i=0 (no next bit).
            for (i = 15; i >= 0; i = i - 1) begin
                // Compare remainder and divisor
                if (remainder >= b_reg) begin
                    quotient[i] = 1'b1;
                    remainder = remainder - b_reg;
                end else begin
                    quotient[i] = 1'b0;
                end

                // Shift remainder left by 1 and concatenate next dividend bit for next iteration if i>0
                if (i > 0)
                    remainder = {remainder[6:0], a_reg[i-1]};
                // For i=0, no next bit to concatenate, end of process
            end
        end

        // Assign outputs
        result = quotient;
        odd    = {8'd0, remainder};  // zero-extend 8-bit remainder to 16 bits
    end

endmodule