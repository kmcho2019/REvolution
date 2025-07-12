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

// State encoding
localparam IDLE = 1'b0;
localparam CALC = 1'b1;

reg state;
reg [3:0] cnt;        // 4-bit counter (0-8)
reg [15:0] SR;        // Shift register [remainder|quotient]
reg [7:0] divisor_abs;
reg dividend_sign, divisor_sign;
reg div_by_zero;

// Precompute absolute values and signs
wire [7:0] dividend_abs = sign & dividend[7] ? -dividend : dividend;
wire [7:0] divisor_abs_pre = sign & divisor[7] ? -divisor : divisor;

// Division logic
wire [8:0] sub_result = {1'b0, SR[15:8]} + {1'b0, ~divisor_abs + 1'b1};
wire carry_out = (sub_result[8:0] >= divisor_abs);  // Simplified comparison
wire [15:0] next_SR = carry_out ? 
    {sub_result[7:0], SR[7:0], 1'b1} : {SR[14:0], 1'b0};

// State transition logic
wire calc_done = (cnt == 4'd8);
wire start_calc = opn_valid && !res_valid && (divisor != 0);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        SR <= 0;
        res_valid <= 0;
        result <= 0;
        dividend_sign <= 0;
        divisor_sign <= 0;
        div_by_zero <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid && !res_valid) begin
                    dividend_sign <= sign & dividend[7];
                    divisor_sign <= sign & divisor[7];
                    divisor_abs <= divisor_abs_pre;
                    div_by_zero <= (divisor == 0);
                    SR <= {8'b0, dividend_abs, 1'b0};
                    cnt <= 0;
                    state <= (divisor == 0) ? IDLE : CALC;
                end
            end
            
            CALC: begin
                SR <= next_SR;
                cnt <= cnt + 1;
                if (calc_done) begin
                    res_valid <= 1;
                    if (div_by_zero) begin
                        result <= 16'hFFFF;  // Error value
                    end else begin
                        // Sign correction
                        result <= {
                            dividend_sign ? -SR[15:8] : SR[15:8],  // remainder
                            (dividend_sign ^ divisor_sign) ? -SR[7:0] : SR[7:0]  // quotient
                        };
                    end
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule