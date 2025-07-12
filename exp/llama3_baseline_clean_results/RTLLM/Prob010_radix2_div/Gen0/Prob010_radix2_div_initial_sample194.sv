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

reg [7:0] SR; // Shift Register for dividend
reg [7:0] NEG_DIVISOR; // Negated absolute value of divisor
reg [3:0] cnt; // Counter for division steps
reg start_cnt; // Flag to start counting
reg [15:0] temp_result; // Temporary result
reg [7:0] abs_dividend; // Absolute value of dividend
reg [7:0] abs_divisor; // Absolute value of divisor
reg prev_opn_valid; // Previous value of opn_valid

always @(posedge clk or posedge rst) begin
    if (rst) begin
        SR <= 0;
        NEG_DIVISOR <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
        prev_opn_valid <= 0;
    end else begin
        if (opn_valid && !prev_opn_valid) begin
            // Save inputs when operation is valid
            abs_dividend <= (sign) ? (~dividend + 1) : dividend;
            abs_divisor <= (sign) ? (~divisor + 1) : divisor;
            NEG_DIVISOR <= (~abs_divisor + 1);
            SR <= {1'b0, abs_dividend};
            cnt <= 1;
            start_cnt <= 1;
        end
        
        if (start_cnt) begin
            if (cnt == 8) begin
                // Division complete
                start_cnt <= 0;
                cnt <= 0;
                // Update result
                temp_result <= {SR[7:0], SR[7:0] - NEG_DIVISOR};
                res_valid <= 1;
            end else begin
                // Perform division step
                reg [8:0] sub_result;
                sub_result <= {1'b0, SR[7:0]} - NEG_DIVISOR;
                if (sub_result[8]) begin
                    // Carry out, insert 0
                    SR <= {1'b0, SR[7:0]} << 1;
                end else begin
                    // No carry out, insert 1
                    SR <= {1'b1, SR[7:0]} << 1;
                end
                cnt <= cnt + 1;
            end
        end
        
        if (res_valid && !opn_valid) begin
            // Result has been consumed, reset validity
            res_valid <= 0;
        end
        
        prev_opn_valid <= opn_valid;
    end
end

always @(*) begin
    if (sign && (dividend[7] == 1'b1)) begin
        // Signed division with negative dividend
        result <= {~temp_result[15:8] + 1, temp_result[7:0]};
    end else if (sign && (divisor[7] == 1'b1)) begin
        // Signed division with negative divisor
        result <= {temp_result[15:8], ~temp_result[7:0] + 1};
    end else begin
        result <= temp_result;
    end
end

endmodule