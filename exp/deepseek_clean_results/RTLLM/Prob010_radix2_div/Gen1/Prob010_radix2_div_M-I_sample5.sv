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

reg [7:0] dividend_abs;
reg [7:0] divisor_abs;
reg dividend_sign;
reg divisor_sign;
reg [15:0] SR;       // Shift register (remainder | quotient)
reg [7:0] neg_divisor;
reg [3:0] cnt;
reg start_div;
wire [8:0] sub_result;
wire carry_out;
reg div_by_zero;

// Subtraction result
assign sub_result = SR[15:8] + neg_divisor;
assign carry_out = ~sub_result[8];  // Carry out is inverted because we added negative

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 16'b0;
        cnt <= 0;
        start_div <= 0;
        SR <= 16'b0;
        div_by_zero <= 0;
    end else begin
        // Clear valid when result is consumed
        if (res_valid) begin
            res_valid <= 0;
        end

        // Operation start
        if (opn_valid && !res_valid && !start_div) begin
            // Handle signed conversion
            dividend_sign <= sign & dividend[7];
            divisor_sign <= sign & divisor[7];
            dividend_abs <= dividend_sign ? ~dividend + 1 : dividend;
            divisor_abs <= divisor_sign ? ~divisor + 1 : divisor;
            
            // Check for division by zero
            div_by_zero <= (divisor == 0);
            
            // Initialize shift register (dividend in upper 8 bits)
            SR <= {dividend_abs, 8'b0};
            neg_divisor <= ~divisor_abs + 1;
            cnt <= 0;
            start_div <= 1;
        end
        
        // Division process
        if (start_div) begin
            if (div_by_zero) begin
                // Handle division by zero
                result <= {8'b0, 8'hFF}; // Max quotient, zero remainder
                res_valid <= 1;
                start_div <= 0;
            end else if (cnt == 8) begin
                // Final result processing
                start_div <= 0;
                
                // Handle negative results
                if (sign) begin
                    // Quotient sign correction
                    if (dividend_sign ^ divisor_sign) begin
                        SR[7:0] <= ~SR[7:0] + 1;
                    end
                    
                    // Remainder sign correction
                    if (dividend_sign) begin
                        SR[15:8] <= ~SR[15:8] + 1;
                    end
                end
                
                result <= SR;
                res_valid <= 1;
            end else begin
                // Perform subtraction and shift
                if (carry_out) begin
                    SR <= {sub_result[7:0], SR[7:1], 1'b1};
                end else begin
                    SR <= {SR[15:8], SR[7:1], 1'b0};
                end
                
                cnt <= cnt + 1;
            end
        end
    end
end

endmodule