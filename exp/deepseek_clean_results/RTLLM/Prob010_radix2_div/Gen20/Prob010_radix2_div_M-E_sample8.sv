module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

// Pipeline stage 1 registers
reg [7:0] dividend_abs_p1;
reg [7:0] divisor_abs_p1;
reg q_sign_p1, r_sign_p1;
reg valid_p1;
reg zero_divisor_p1;

// Pipeline stage 2 registers
reg [15:0] sr_p2;  // {remainder, quotient}
reg [7:0] divisor_abs_p2;
reg q_sign_p2, r_sign_p2;
reg [3:0] cnt_p2;
reg valid_p2;
reg zero_divisor_p2;

// Absolute value calculation
function [7:0] abs_val;
    input [7:0] val;
    input is_signed;
    begin
        abs_val = is_signed & val[7] ? -val : val;
    end
endfunction

// Pipeline stage 1: Input conditioning
always @(posedge clk or posedge rst) begin
    if (rst) begin
        valid_p1 <= 0;
        zero_divisor_p1 <= 0;
    end else begin
        valid_p1 <= opn_valid && !res_valid;
        if (opn_valid && !res_valid) begin
            dividend_abs_p1 <= abs_val(dividend, sign);
            divisor_abs_p1 <= abs_val(divisor, sign);
            q_sign_p1 <= sign & (dividend[7] ^ divisor[7]);
            r_sign_p1 <= sign & dividend[7];
            zero_divisor_p1 <= (divisor == 0);
        end
    end
end

// Pipeline stage 2: Core division
always @(posedge clk or posedge rst) begin
    if (rst) begin
        valid_p2 <= 0;
        cnt_p2 <= 0;
        res_valid <= 0;
    end else begin
        valid_p2 <= valid_p1;
        zero_divisor_p2 <= zero_divisor_p1;
        
        if (valid_p1) begin
            // Initialize for new division
            divisor_abs_p2 <= divisor_abs_p1;
            q_sign_p2 <= q_sign_p1;
            r_sign_p2 <= r_sign_p1;
            
            if (zero_divisor_p1) begin
                // Handle divide by zero case
                sr_p2 <= {8'hFF, 8'hFF}; // Max values as error indication
                cnt_p2 <= 8;
            end else begin
                sr_p2 <= {8'b0, dividend_abs_p1};
                cnt_p2 <= 0;
            end
        end else if (valid_p2 && cnt_p2 < 8) begin
            // Non-restoring division step
            if (sr_p2[15:8] >= divisor_abs_p2) begin
                sr_p2 <= {(sr_p2[15:8] - divisor_abs_p2), sr_p2[6:0], 1'b1};
            end else begin
                sr_p2 <= {sr_p2[14:0], 1'b0};
            end
            cnt_p2 <= cnt_p2 + 1;
        end
        
        // Output stage
        res_valid <= valid_p2 && (cnt_p2 == 8);
        if (valid_p2 && (cnt_p2 == 8)) begin
            // Final remainder correction if needed
            if (sr_p2[15] && !zero_divisor_p2) begin
                result[15:8] <= r_sign_p2 ? -(sr_p2[15:8] + divisor_abs_p2) : 
                                          (sr_p2[15:8] + divisor_abs_p2);
            end else begin
                result[15:8] <= r_sign_p2 ? -sr_p2[15:8] : sr_p2[15:8];
            end
            
            // Quotient
            result[7:0] <= zero_divisor_p2 ? 8'hFF : 
                          (q_sign_p2 ? -sr_p2[7:0] : sr_p2[7:0]);
        end
    end
end

endmodule