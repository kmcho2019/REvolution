module radix2_div(
    input clk, 
    input rst, 
    input sign, 
    input [7:0] dividend, 
    input [7:0] divisor, 
    input opn_valid,
    output res_valid,
    output [15:0] result
);

reg [15:0] SR; // Shift Register to store the result
reg [7:0] NEG_DIVISOR; // Negated absolute value of the divisor
reg [2:0] cnt; // Counter to track the number of division steps
reg start_cnt; // Flag to indicate the start of division
reg [7:0] dividend_reg; // Registered dividend value
reg [7:0] divisor_reg; // Registered divisor value

// Initialize variables on reset
always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
        SR <= 0;
        NEG_DIVISOR <= 0;
        cnt <= 0;
        start_cnt <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
    end
    else if (opn_valid && !res_valid) begin
        // Save inputs on valid operation request
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        // Initialize shift register with absolute value of dividend shifted left by one bit
        if (sign) begin
            SR <= {{8{dividend_reg[7]}}, dividend_reg};
        end
        else begin
            SR <= {8'd0, dividend_reg};
        end
        // Set NEG_DIVISOR to negated absolute value of divisor
        if (sign && divisor_reg[7]) begin
            NEG_DIVISOR <= ~({8'd0, divisor_reg});
        end
        else if (sign) begin
            NEG_DIVISOR <= ~({8'd0, ~divisor_reg});
        end
        else begin
            NEG_DIVISOR <= {8'd0, ~divisor_reg};
        end
        // Set counter and start_cnt
        cnt <= 1;
        start_cnt <= 1;
    end
    else if (start_cnt) begin
        // Division process
        if (cnt == 8'd8) begin
            // Division complete
            cnt <= 0;
            start_cnt <= 0;
            // Update shift register with final remainder and quotient
            result <= {SR[15:8], SR[7:0]};
            res_valid <= 1;
        end
        else begin
            // Compute subtraction
            reg [8:0] sub_result;
            sub_result = {1'd0, SR[15:8]} - {1'd0, divisor_reg};
            // Update SR based on carry-out
            if (sub_result[8]) begin
                SR <= {1'd1, SR[15:8] - divisor_reg, 1'd0};
            end
            else begin
                SR <= {1'd0, SR[15:8] - divisor_reg, 1'd1};
            end
            cnt <= cnt + 1;
        end
    end
    else if (res_valid) begin
        // Reset result validity when result is consumed
        res_valid <= 0;
    end
end

endmodule