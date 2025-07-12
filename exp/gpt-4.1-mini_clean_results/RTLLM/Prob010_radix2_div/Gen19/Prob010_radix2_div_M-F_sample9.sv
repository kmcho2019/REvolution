module radix2_div (
    input              clk,
    input              rst,
    input              sign,
    input      [7:0]   dividend,
    input      [7:0]   divisor,
    input              opn_valid,
    output reg         res_valid,
    output reg [15:0]  result  // [15:8] = remainder, [7:0] = quotient
);

    reg [3:0] cnt;
    reg       start_cnt;

    reg       quotient_sign;
    reg       remainder_sign;

    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;

    // SR: [16:8] partial remainder (9 bits), [7:0] quotient
    reg [16:0] SR;

    // Partial remainder as signed 9-bit (1 sign bit + 8 bits)
    wire signed [8:0] partial_rem = SR[16:8];
    // Trial subtraction: partial remainder - divisor
    wire signed [8:0] trial_sub = partial_rem - {1'b0, abs_divisor};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt           <= 4'd0;
            start_cnt     <= 1'b0;
            res_valid     <= 1'b0;
            result        <= 16'd0;
            quotient_sign <= 1'b0;
            remainder_sign<= 1'b0;
            abs_dividend  <= 8'd0;
            abs_divisor   <= 8'd0;
            SR            <= 17'd0;
        end else begin
            if (!start_cnt) begin
                res_valid <= 1'b0;
                if (opn_valid) begin
                    // Calculate quotient and remainder signs for signed operation
                    quotient_sign  <= sign & (dividend[7] ^ divisor[7]);
                    remainder_sign <= sign & dividend[7];

                    // Absolute values for division inputs
                    abs_dividend <= (sign && dividend[7]) ? (~dividend + 1'b1) : dividend;
                    abs_divisor  <= (sign && divisor[7])  ? (~divisor + 1'b1)  : divisor;

                    // Initialize SR: partial remainder = dividend shifted left by 1, quotient = 0
                    // partial remainder width = 9 bits: dividend[7:0] << 1 => 8 bits + 1 LSB zero
                    SR <= {abs_dividend, 1'b0, 8'd0};

                    cnt       <= 4'd1;
                    start_cnt <= 1'b1;
                end
            end else begin
                // Division in progress
                if (cnt == 4'd8) begin
                    // Division complete
                    start_cnt <= 1'b0;
                    cnt       <= 4'd0;
                    res_valid <= 1'b1;

                    // Extract quotient and remainder from SR
                    // Quotient = SR[7:0]
                    // Remainder = SR[16:9] (upper 8 bits of partial remainder)
                    // Correct signs if operation is signed

                    if (quotient_sign)
                        result[7:0] <= (~SR[7:0]) + 1'b1;
                    else
                        result[7:0] <= SR[7:0];

                    if (remainder_sign)
                        result[15:8] <= (~SR[16:9]) + 1'b1;
                    else
                        result[15:8] <= SR[16:9];
                end else begin
                    // Iterative division step
                    if (trial_sub[8] == 1'b0) begin
                        // subtraction successful (non-negative)
                        // Shift SR left by 1, insert bit '1' into quotient LSB
                        SR <= {trial_sub[7:0], SR[7:0], 1'b1};
                    end else begin
                        // subtraction negative, restore partial remainder
                        // Shift SR left by 1, insert bit '0' into quotient LSB
                        SR <= {partial_rem[7:0], SR[7:0], 1'b0};
                    end
                    cnt <= cnt + 1'b1;
                    res_valid <= 1'b0;
                end
            end
        end
    end

endmodule