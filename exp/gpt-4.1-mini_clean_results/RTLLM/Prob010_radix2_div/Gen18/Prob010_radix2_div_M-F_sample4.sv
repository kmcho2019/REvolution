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
    reg start_cnt;

    reg quotient_sign, remainder_sign;
    reg [7:0] abs_dividend, abs_divisor;

    // Shift register holding {partial_remainder[8:0], quotient[7:0]}
    reg [16:0] SR;

    wire signed [8:0] partial_rem = SR[16:8];

    // Wires for subtraction
    wire signed [9:0] diff = partial_rem - {1'b0, abs_divisor};
    wire             diff_non_neg = ~diff[9]; // diff >= 0 if MSB=0

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
                if (opn_valid && !res_valid) begin
                    // Capture signs and absolute values
                    quotient_sign  <= sign & (dividend[7] ^ divisor[7]);
                    remainder_sign <= sign & dividend[7];
                    abs_dividend   <= (sign && dividend[7]) ? (~dividend + 1) : dividend;
                    abs_divisor    <= (sign && divisor[7])  ? (~divisor + 1)  : divisor;

                    // Initialize SR: partial remainder = dividend abs shifted left by 1, quotient = 0
                    // SR = {partial_rem[8:0], quotient[7:0]} = {abs_dividend,1'b0,8'd0}
                    SR <= {abs_dividend, 1'b0, 8'd0};

                    cnt       <= 4'd1;
                    start_cnt <= 1'b1;
                end
            end else begin
                // Division iteration step
                // Perform trial subtraction if possible
                if (diff_non_neg) begin
                    // subtraction successful: update remainder = diff, quotient bit = 1
                    SR <= {diff[8:0], SR[7:1], 1'b1};
                end else begin
                    // subtraction failed: remainder unchanged, quotient bit = 0
                    SR <= {partial_rem, SR[7:1], 1'b0};
                end

                if (cnt == 4'd8) begin
                    // End of division iterations
                    start_cnt <= 1'b0;
                    cnt       <= 4'd0;
                    res_valid <= 1'b1;

                    // Adjust quotient sign
                    if (quotient_sign)
                        result[7:0] <= ~SR[7:0] + 1;
                    else
                        result[7:0] <= SR[7:0];

                    // Adjust remainder sign
                    // partial remainder is 9 bits: SR[16:8], but remainder is 8 bits
                    // The remainder is stored in upper 8 bits of result
                    if (remainder_sign)
                        result[15:8] <= ~SR[16:9] + 1;
                    else
                        result[15:8] <= SR[16:9];
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end

endmodule