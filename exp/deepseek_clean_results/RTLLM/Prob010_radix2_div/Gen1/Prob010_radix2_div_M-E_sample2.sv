module radix2_div (
    input wire clk,
    input wire rst,
    input wire sign,
    input wire [7:0] dividend,
    input wire [7:0] divisor,
    input wire opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

// Pipeline registers
reg [7:0] dividend_pipe;
reg [7:0] divisor_pipe;
reg sign_pipe;
reg opn_valid_pipe;

// Special case detection signals
wire divisor_is_zero = (divisor == 8'b0);
wire divisor_is_one = (divisor == 8'b1);
wire special_case = divisor_is_zero | divisor_is_one;

// Absolute values
wire [7:0] abs_dividend = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] abs_divisor = (sign & divisor[7]) ? -divisor : divisor;

// Sign tracking
reg dividend_sign;
reg divisor_sign;
reg result_sign;

// Division algorithm registers
reg [7:0] remainder;
reg [7:0] quotient;
reg [3:0] iteration;
reg computing;
reg done;

// Early termination result
wire [15:0] early_result = divisor_is_zero ? 16'hFFFF : 
                          {8'b0, abs_dividend};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset all registers
        dividend_pipe <= 8'b0;
        divisor_pipe <= 8'b0;
        sign_pipe <= 1'b0;
        opn_valid_pipe <= 1'b0;
        
        remainder <= 8'b0;
        quotient <= 8'b0;
        iteration <= 4'b0;
        computing <= 1'b0;
        done <= 1'b0;
        
        dividend_sign <= 1'b0;
        divisor_sign <= 1'b0;
        result_sign <= 1'b0;
        
        res_valid <= 1'b0;
        result <= 16'b0;
    end else begin
        // Pipeline stage 1: Input processing
        if (opn_valid && !computing && !done) begin
            dividend_pipe <= dividend;
            divisor_pipe <= divisor;
            sign_pipe <= sign;
            opn_valid_pipe <= 1'b1;
            
            // Store signs for later correction
            dividend_sign <= sign & dividend[7];
            divisor_sign <= sign & divisor[7];
            
            if (special_case) begin
                // Handle special cases immediately
                result <= early_result;
                res_valid <= 1'b1;
                done <= 1'b1;
            end else begin
                // Initialize division algorithm
                remainder <= 8'b0;
                quotient <= abs_dividend;
                iteration <= 4'b0;
                computing <= 1'b1;
            end
        end else begin
            opn_valid_pipe <= 1'b0;
        end

        // Pipeline stage 2: Division computation
        if (computing) begin
            if (iteration == 4'd8) begin
                // Division complete
                computing <= 1'b0;
                done <= 1'b1;
                
                // Final remainder adjustment for non-restoring division
                if (remainder[7]) begin
                    remainder <= remainder + abs_divisor;
                end
                
                // Apply sign correction if signed operation
                if (sign_pipe) begin
                    quotient <= (dividend_sign ^ divisor_sign) ? -quotient : quotient;
                    remainder <= dividend_sign ? -remainder : remainder;
                end
                
                result <= {remainder, quotient};
                res_valid <= 1'b1;
            end else begin
                // Radix-2 division step
                {remainder, quotient} = {remainder[6:0], quotient, 1'b0};
                
                // Parallel remainder calculation
                if (remainder[7] == 1'b0) begin
                    remainder = remainder - abs_divisor;
                    quotient[0] = 1'b1;
                end else begin
                    remainder = remainder + abs_divisor;
                    quotient[0] = 1'b0;
                end
                
                iteration <= iteration + 1;
            end
        end

        // Clear done flag when operation is complete
        if (done && !opn_valid) begin
            done <= 1'b0;
            res_valid <= 1'b0;
        end
    end
end

endmodule