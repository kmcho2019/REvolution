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

// Internal registers
reg [7:0] remainder, quotient;
reg [7:0] divisor_reg;
reg sign_q, sign_r;
reg [3:0] cnt;
reg active;
reg zero_divisor;

// Sign handling
wire dividend_sign = sign & dividend[7];
wire divisor_sign = sign & divisor[7];

// Absolute values calculation
wire [7:0] abs_dividend = dividend_sign ? -dividend : dividend;
wire [7:0] abs_divisor = divisor_sign ? -divisor : divisor;

// Division signals
wire [8:0] sub_result = {remainder, quotient[7]} + {1'b0, ~divisor_reg + 8'd1};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
        result <= 16'd0;
        cnt <= 4'd0;
        active <= 1'b0;
        remainder <= 8'd0;
        quotient <= 8'd0;
        divisor_reg <= 8'd0;
        zero_divisor <= 1'b0;
        sign_q <= 1'b0;
        sign_r <= 1'b0;
    end else begin
        if (opn_valid && !active) begin
            // Initialize operation
            divisor_reg <= abs_divisor;
            sign_q <= dividend_sign ^ divisor_sign;
            sign_r <= dividend_sign;
            zero_divisor <= (divisor == 8'd0);
            
            // Initialize division registers
            remainder <= 8'd0;
            quotient <= abs_dividend;
            
            cnt <= 4'd0;
            active <= 1'b1;
            res_valid <= 1'b0;
        end else if (active) begin
            if (zero_divisor) begin
                // Handle division by zero
                result <= 16'hFFFF;
                res_valid <= 1'b1;
                active <= 1'b0;
            end else if (cnt == 4'd8 || remainder == 8'd0) begin
                // Finalize operation
                if (sign) begin
                    result[7:0] <= sign_q ? -quotient : quotient;
                    result[15:8] <= sign_r ? -remainder : remainder;
                end else begin
                    result[7:0] <= quotient;
                    result[15:8] <= remainder;
                end
                res_valid <= 1'b1;
                active <= 1'b0;
            end else begin
                // Perform division step
                cnt <= cnt + 4'd1;
                
                if (sub_result[8]) begin
                    // No carry - shift only
                    remainder <= {remainder[6:0], quotient[7]};
                    quotient <= {quotient[6:0], 1'b0};
                end else begin
                    // Carry - update remainder and quotient
                    remainder <= sub_result[7:0];
                    quotient <= {quotient[6:0], 1'b1};
                end
            end
        end else begin
            res_valid <= 1'b0;
        end
    end
end

endmodule