module div_16bit (
    input  wire [15:0] A,        // Dividend
    input  wire [7:0]  B,        // Divisor
    output reg  [15:0] result,   // Quotient
    output reg  [15:0] odd       // Remainder (lower 8 bits valid, upper 8 bits zero)
);

    reg [15:0] a_reg;
    reg [7:0]  b_reg;

    // First combinational always block: latch inputs
    always @(*) begin
        a_reg = A;
        b_reg = B;
    end

    // Second combinational always block: non-restoring division
    always @(*) begin
        integer i;
        reg signed [8:0] remainder; // 9 bits to hold sign + 8 bits divisor width
        reg [15:0] quotient_tmp;

        remainder = 9'd0;
        quotient_tmp = 16'd0;

        // Process each bit from MSB to LSB
        for (i = 15; i >= 0; i = i - 1) begin
            // Shift left remainder by 1 and bring in next bit of dividend
            remainder = {remainder[7:0], a_reg[i]};

            if (remainder[8] == 1'b1) begin
                // remainder negative, add divisor
                remainder = remainder + {1'b0, b_reg};
                quotient_tmp[i] = 1'b0;
            end else begin
                // remainder positive or zero, subtract divisor
                remainder = remainder - {1'b0, b_reg};
                quotient_tmp[i] = 1'b1;
            end
        end

        // Final correction: if remainder negative, add divisor back
        if (remainder[8] == 1'b1)
            remainder = remainder + {1'b0, b_reg};

        // Assign outputs
        result = quotient_tmp;
        odd = {8'd0, remainder[7:0]}; // zero-extend remainder to 16 bits
    end

endmodule