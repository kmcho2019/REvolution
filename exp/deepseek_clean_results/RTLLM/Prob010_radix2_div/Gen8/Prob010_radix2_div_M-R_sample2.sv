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

// State definitions
localparam IDLE = 1'b0;
localparam CALC = 1'b1;

reg state;
reg [3:0] cnt;  // Fixed to 4 bits for 0-8 count
reg [15:0] SR;  // Shift register: [remainder|quotient]
reg [7:0] divisor_abs;
reg dividend_sign, divisor_sign;
reg div_by_zero;

// Combinational logic
wire [7:0] dividend_abs = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] divisor_twos_comp = -divisor;
wire [8:0] sub_result = {1'b0, SR[15:8]} + {1'b0, ~divisor_abs + 1'b1};
wire carry_out = ~sub_result[8];  // Positive result means no borrow
wire [15:0] next_SR = carry_out ? {sub_result[7:0], SR[7:0], 1'b1} : {SR[14:0], 1'b0};
wire calc_done = (cnt == 4'd8);

// Next state logic
wire start_calc = (state == IDLE) && opn_valid && !res_valid && !div_by_zero;
wire next_state = start_calc ? CALC : (calc_done ? IDLE : state);

// Result assembly
wire [15:0] final_result = div_by_zero ? {8'hFF, 8'hFF} : 
    {dividend_sign ? -SR[15:8] : SR[15:8],
     (dividend_sign ^ divisor_sign) ? -SR[7:0] : SR[7:0]};

// Sequential logic
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
        state <= next_state;
        
        if (state == IDLE) begin
            res_valid <= 0;
            if (opn_valid && !res_valid) begin
                dividend_sign <= sign & dividend[7];
                divisor_sign <= sign & divisor[7];
                divisor_abs <= (sign & divisor[7]) ? divisor_twos_comp : divisor;
                div_by_zero <= (divisor == 0);
                SR <= {8'b0, dividend_abs, 1'b0};
                cnt <= 0;
            end
        end else if (state == CALC) begin
            SR <= next_SR;
            cnt <= cnt + 1;
            if (calc_done) begin
                res_valid <= 1;
                result <= final_result;
            end
        end
    end
end

endmodule