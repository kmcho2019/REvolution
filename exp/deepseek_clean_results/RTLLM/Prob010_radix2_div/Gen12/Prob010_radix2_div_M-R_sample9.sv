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

// State parameters
localparam IDLE = 1'b0;
localparam CALC = 1'b1;

// Internal registers
reg state;
reg [3:0] cnt;
reg [15:0] SR;
reg [7:0] divisor_reg;
reg dividend_sign, divisor_sign;

// Absolute value calculations
wire [7:0] dividend_abs = sign & dividend[7] ? -dividend : dividend;
wire [7:0] divisor_abs = sign & divisor[7] ? -divisor : divisor;

// Division logic
wire [8:0] sub_result = {SR[15], SR[15:8]} + {1'b1, ~divisor_reg + 1'b1};
wire carry_out = ~sub_result[8];
wire [15:0] next_SR = carry_out ? {sub_result[7:0], SR[7:0], 1'b1} : {SR[14:0], 1'b0};

// Control signals
wire calc_done = (cnt == 4'd8);
wire start_calc = opn_valid && (state == IDLE) && (divisor != 0);
wire div_by_zero = opn_valid && (divisor == 0);

// Next state logic
wire next_state = (state == IDLE) ? (start_calc ? CALC : IDLE) :
                 (calc_done ? IDLE : CALC);

// Counter logic
wire [3:0] next_cnt = (state == IDLE) ? 4'd0 : 
                     (calc_done ? 4'd0 : cnt + 1);

// Shift register update logic
wire [15:0] next_SR_load = {8'b0, dividend_abs, 1'b0};
wire [15:0] next_SR_value = (state == IDLE) ? next_SR_load : next_SR;

// Result sign correction
wire [7:0] corrected_remainder = dividend_sign ? -SR[15:8] : SR[15:8];
wire [7:0] corrected_quotient = (dividend_sign ^ divisor_sign) ? -SR[7:0] : SR[7:0];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        SR <= 0;
        res_valid <= 0;
        result <= 0;
        dividend_sign <= 0;
        divisor_sign <= 0;
        divisor_reg <= 0;
    end else begin
        state <= next_state;
        cnt <= next_cnt;
        SR <= next_SR_value;
        res_valid <= (state == CALC) && calc_done;
        
        if (start_calc) begin
            dividend_sign <= sign & dividend[7];
            divisor_sign <= sign & divisor[7];
            divisor_reg <= divisor_abs;
        end
        
        if (div_by_zero) begin
            result <= 16'hFFFF;
            res_valid <= 1;
        end else if ((state == CALC) && calc_done) begin
            result <= {corrected_remainder, corrected_quotient};
        end
    end
end

endmodule