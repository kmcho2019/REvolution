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
reg [7:0] u_remainder, u_quotient;
reg [7:0] s_remainder, s_quotient;
reg [7:0] divisor_abs;
reg [7:0] dividend_abs;
reg sign_q, sign_r;
reg [3:0] cnt;
reg active;
reg zero_divisor;

// Sign handling
wire dividend_sign = sign & dividend[7];
wire divisor_sign = sign & divisor[7];

// Absolute values
wire [7:0] abs_dividend = dividend_sign ? -dividend : dividend;
wire [7:0] abs_divisor = divisor_sign ? -divisor : divisor;

// Division signals
wire [8:0] u_sub = {u_remainder, u_quotient[7]} + {1'b0, ~divisor_abs + 1};
wire [8:0] s_sub = {s_remainder, s_quotient[7]} + {1'b0, ~divisor_abs + 1};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        active <= 0;
        u_remainder <= 0;
        u_quotient <= 0;
        s_remainder <= 0;
        s_quotient <= 0;
        zero_divisor <= 0;
    end else begin
        if (opn_valid && !active) begin
            // Initialize operation
            divisor_abs <= abs_divisor;
            dividend_abs <= abs_dividend;
            sign_q <= dividend_sign ^ divisor_sign;
            sign_r <= dividend_sign;
            zero_divisor <= (divisor == 0);
            
            // Initialize unsigned path
            u_remainder <= 0;
            u_quotient <= abs_dividend;
            
            // Initialize signed path
            s_remainder <= 0;
            s_quotient <= abs_dividend;
            
            cnt <= 0;
            active <= 1;
            res_valid <= 0;
        end else if (active) begin
            if (zero_divisor) begin
                // Handle division by zero
                result <= {8'hFF, 8'hFF};
                res_valid <= 1;
                active <= 0;
            end else if (cnt == 8 || (u_remainder == 0 && !sign) || (s_remainder == 0 && sign)) begin
                // Finalize operation
                if (sign) begin
                    result[7:0] <= sign_q ? -s_quotient : s_quotient;
                    result[15:8] <= sign_r ? -s_remainder : s_remainder;
                end else begin
                    result[7:0] <= u_quotient;
                    result[15:8] <= u_remainder;
                end
                res_valid <= 1;
                active <= 0;
            end else begin
                // Perform division step
                cnt <= cnt + 1;
                
                // Unsigned path
                if (u_sub[8]) begin
                    u_remainder <= {u_remainder[6:0], u_quotient[7]};
                    u_quotient <= {u_quotient[6:0], 1'b0};
                end else begin
                    u_remainder <= u_sub[7:0];
                    u_quotient <= {u_quotient[6:0], 1'b1};
                end
                
                // Signed path
                if (s_sub[8]) begin
                    s_remainder <= {s_remainder[6:0], s_quotient[7]};
                    s_quotient <= {s_quotient[6:0], 1'b0};
                end else begin
                    s_remainder <= s_sub[7:0];
                    s_quotient <= {s_quotient[6:0], 1'b1};
                end
            end
        end else begin
            res_valid <= 0;
        end
    end
end

endmodule