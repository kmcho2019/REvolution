module radix2_div (
    input              clk,
    input              rst,
    input              sign,
    input      [7:0]   dividend,
    input      [7:0]   divisor,
    input              opn_valid,
    output reg         res_valid,
    output reg [15:0]  result
);

    reg [3:0] cnt;
    reg start;

    reg quotient_sign, remainder_sign;
    reg [7:0] abs_dividend, abs_divisor;

    // 17-bit shift register: {partial_remainder[8:0], quotient[7:0]} (partial remainder is 9 bits for sign extension)
    reg [16:0] SR;

    wire signed [8:0] partial_rem = SR[16:8];

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt         <= 4'd0;
            start       <= 1'b0;
            res_valid   <= 1'b0;
            result      <= 16'd0;
            quotient_sign   <= 1'b0;
            remainder_sign  <= 1'b0;
            abs_dividend    <= 8'd0;
            abs_divisor     <= 8'd0;
            SR          <= 17'd0;
        end else begin
            if (!start) begin
                res_valid <= 1'b0;
                if (opn_valid) begin
                    // Determine sign and absolute values
                    quotient_sign  <= sign & (dividend[7] ^ divisor[7]);
                    remainder_sign <= sign & dividend[7];

                    abs_dividend <= (sign && dividend[7]) ? (~dividend + 1) : dividend;
                    abs_divisor  <= (sign && divisor[7]) ? (~divisor + 1) : divisor;

                    // Initialize shift register: partial remainder = dividend abs shifted left by 1, quotient = 0
                    // SR = {partial_rem[8:0], quotient[7:0]} = {abs_dividend, 1'b0, 8'd0}
                    SR <= {abs_dividend, 1'b0, 8'd0};

                    cnt   <= 4'd0;
                    start <= 1'b1;
                end
            end else begin
                // Division iteration
                // Shift left SR by 1
                SR <= {SR[15:0], 1'b0};

                // Trial subtraction: partial remainder - divisor
                // partial remainder is top 9 bits of SR after shift: SR[16:8]
                if ($signed({1'b0, SR[16:8]}) >= $signed({1'b0, abs_divisor})) begin
                    // Subtract divisor, set LSB of quotient to 1
                    SR[16:8] <= $signed({1'b0, SR[16:8]}) - $signed({1'b0, abs_divisor});
                    SR[0] <= 1'b1; // quotient LSB set to 1
                end else begin
                    // Keep partial remainder, quotient LSB is 0 (already zero after shift)
                    SR[16:8] <= SR[16:8];
                    SR[0] <= 1'b0;
                end

                cnt <= cnt + 1'b1;

                if (cnt == 4'd7) begin
                    // Division complete
                    start <= 1'b0;
                    res_valid <= 1'b1;

                    // Retrieve quotient and remainder
                    // Quotient = lower 8 bits SR[7:0]
                    // Remainder = upper 8 bits SR[16:9] (9 bits partial remainder shifted down one bit)
                    // Adjust signs if signed
                    if (quotient_sign)
                        result[7:0] <= ~SR[7:0] + 1;
                    else
                        result[7:0] <= SR[7:0];

                    if (remainder_sign)
                        result[15:8] <= ~SR[16:9] + 1;
                    else
                        result[15:8] <= SR[16:9];
                end
            end
        end
    end

endmodule