module div_16bit (
    input  wire [15:0] A,      // Dividend
    input  wire [7:0]  B,      // Divisor
    output reg  [15:0] result, // Quotient
    output reg  [15:0] odd     // Remainder (only lower 8 bits valid)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // Capture inputs into registers (combinational)
    always @* begin
        a_reg = A;
        b_reg = B;
    end

    integer i;
    reg [15:0] quotient;
    reg [15:0] remainder;

    // Division process (combinational)
    always @* begin
        // Initialize remainder with top 8 bits of dividend
        remainder = {8'd0, a_reg[15:8]};
        quotient = 16'd0;

        // Iterate over lower 8 bits of dividend
        for (i = 7; i >= 0; i = i - 1) begin
            // Shift remainder left by 1 and bring down next bit of dividend
            remainder = {remainder[14:0], a_reg[i]};
            // Compare remainder with divisor (b_reg)
            if (remainder[15:8] >= b_reg) begin
                // Subtract divisor from remainder upper byte
                remainder[15:8] = remainder[15:8] - b_reg;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        // Now process the lowest 8 bits of the quotient and remainder
        // For bits 15:8 of quotient, which correspond to initial check of high bits

        // The problem states to extract highest bits of dividend matching divisor width,
        // compare and set quotient bit accordingly, repeating for all dividend bits
        // Here, we processed bits 7:0 already, now process bits 15:8 similarly:

        // Initialize remainder with zero for bits 15:8 processing
        remainder = 16'd0;
        // Process bits 15 down to 8 of dividend
        for (i = 15; i >= 8; i = i - 1) begin
            remainder = {remainder[14:0], a_reg[i]};
            if (remainder[15:8] >= b_reg) begin
                remainder[15:8] = remainder[15:8] - b_reg;
                quotient[i] = 1'b1;
            end else begin
                quotient[i] = 1'b0;
            end
        end

        // Assign results
        result = quotient;
        odd = remainder;
    end

endmodule