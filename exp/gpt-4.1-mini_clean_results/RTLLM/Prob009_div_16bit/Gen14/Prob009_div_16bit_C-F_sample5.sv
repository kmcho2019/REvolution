module div_16bit (
    input  wire [15:0] A,       // Dividend
    input  wire [7:0]  B,       // Divisor
    output reg  [15:0] result,  // Quotient
    output reg  [15:0] odd      // Remainder (lower 8 bits valid)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // First combinational always block: latch inputs
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second combinational always block: division logic
    always @(*) begin
        integer i;
        reg [8:0] rem_stages [0:16];  // 9-bit remainder stages (0 to 16)
        reg [15:0] quotient_tmp;

        // Initialize remainder stage 0 to zero
        rem_stages[0] = 9'd0;

        // Iterative division from MSB to LSB
        for (i = 0; i < 16; i = i + 1) begin
            reg [8:0] rem_shifted;
            reg [8:0] rem_sub;
            reg       bit_set;

            // Shift previous remainder left by 1 and bring down next dividend bit
            rem_shifted = {rem_stages[i][7:0], a_reg[15 - i]};
            rem_sub = rem_shifted - {1'b0, b_reg};
            bit_set = (rem_shifted >= {1'b0, b_reg});

            // Update remainder stage for next iteration
            rem_stages[i + 1] = bit_set ? rem_sub : rem_shifted;

            // Assign quotient bit MSB first
            quotient_tmp[15 - i] = bit_set;
        end

        // Assign outputs
        result = quotient_tmp;
        odd = {8'd0, rem_stages[16][7:0]};
    end

endmodule