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

// States
typedef enum logic [1:0] {
    IDLE,
    CALC,
    DONE
} state_t;

reg [1:0] state, next_state;
reg [3:0] cnt;
reg [15:0] SR;       // Shift register: [remainder|quotient]
reg [7:0] dividend_abs;
reg [7:0] divisor_abs;
reg dividend_sign;
reg divisor_sign;
reg div_by_zero;

// Continuous assignments
wire [7:0] dividend_twos_comp = -dividend;
wire [7:0] divisor_twos_comp = -divisor;
wire [8:0] sub_result = {1'b0, SR[15:8]} + {1'b0, ~divisor_abs + 1'b1};
wire carry_out = ~sub_result[8];  // Positive result means no borrow
wire [15:0] next_SR = carry_out ? {sub_result[7:0], SR[7:0], 1'b1} : {SR[14:0], 1'b0};

// State transition logic
always_comb begin
    next_state = state;
    case (state)
        IDLE: if (opn_valid && !res_valid) 
            next_state = div_by_zero ? DONE : CALC;
        CALC: if (cnt == 8)
            next_state = DONE;
        DONE: if (opn_valid) 
            next_state = IDLE;
    endcase
end

// Sign handling and absolute value calculation
always @(posedge clk) begin
    if (state == IDLE && opn_valid && !res_valid) begin
        dividend_sign <= sign & dividend[7];
        divisor_sign <= sign & divisor[7];
        dividend_abs <= (sign & dividend[7]) ? dividend_twos_comp : dividend;
        divisor_abs <= (sign & divisor[7]) ? divisor_twos_comp : divisor;
        div_by_zero <= (divisor == 0);
    end
end

// Main sequential logic
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
        
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid && !res_valid) begin
                    SR <= {8'b0, dividend_abs, 1'b0};
                    cnt <= 0;
                end
            end
            
            CALC: begin
                SR <= next_SR;
                cnt <= cnt + 1;
            end
            
            DONE: begin
                res_valid <= 1;
                if (div_by_zero) begin
                    result <= {8'hFF, 8'hFF};
                end else begin
                    result <= {
                        dividend_sign ? -SR[15:8] : SR[15:8],
                        (dividend_sign ^ divisor_sign) ? -SR[7:0] : SR[7:0]
                    };
                end
            end
        endcase
    end
end

endmodule