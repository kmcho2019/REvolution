module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output res_valid,
    output [15:0] result
);

reg [7:0] SR; // Shift Register
reg [7:0] NEG_DIVISOR; // Negated absolute value of divisor
reg [2:0] cnt; // Counter
reg start_cnt; // Start counter flag
reg [7:0] dividend_reg; // Registered dividend
reg [7:0] divisor_reg; // Registered divisor
reg result_valid; // Result validity flag
reg [15:0] result_reg; // Registered result

// Initialize shift register SR with absolute value of dividend shifted left by one bit
always @(posedge clk) begin
    if (rst) begin
        SR <= 8'b0;
        NEG_DIVISOR <= 8'b0;
        cnt <= 3'b0;
        start_cnt <= 1'b0;
        dividend_reg <= 8'b0;
        divisor_reg <= 8'b0;
        result_valid <= 1'b0;
        result_reg <= 16'b0;
    end else if (opn_valid && !res_valid) begin
        // Save inputs
        dividend_reg <= dividend;
        divisor_reg <= divisor;

        // Initialize shift register SR with absolute value of dividend shifted left by one bit
        if (sign) begin
            SR <= {1'b0, (dividend[7] ? (~dividend_reg + 1) : dividend_reg)};
        end else begin
            SR <= {1'b0, dividend_reg};
        end

        // Set NEG_DIVISOR to negated absolute value of divisor
        if (sign) begin
            NEG_DIVISOR <= ~(divisor[7] ? (~divisor_reg + 1) : divisor_reg) + 1;
        end else begin
            NEG_DIVISOR <= ~divisor_reg + 1;
        end

        // Set counter cnt to 1 and start_cnt to 1
        cnt <= 1;
        start_cnt <= 1'b1;
    end else if (start_cnt) begin
        // Perform division
        if (cnt == 8) begin
            // Division complete, update result
            result_reg <= {SR[7:0], SR[7] ? (~SR[7:0] + 1) : SR[7:0]};
            result_valid <= 1'b1;
            start_cnt <= 1'b0;
            cnt <= 3'b0;
        end else begin
            // Update shift register SR
            reg [8:0] sub_result;
            sub_result <= SR - NEG_DIVISOR;
            if (sub_result[8]) begin
                SR <= {1'b1, SR[7:1]};
            end else begin
                SR <= {1'b0, (SR[7:0] + NEG_DIVISOR)[7:1]};
            end
            cnt <= cnt + 1;
        end
    end
end

assign res_valid = result_valid;
assign result = result_reg;

endmodule