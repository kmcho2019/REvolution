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

// Pipeline stages
typedef enum logic [1:0] {
    STAGE_INPUT,
    STAGE_CALC,
    STAGE_OUTPUT
} stage_t;

// Special case flags
typedef struct packed {
    logic div_by_zero;
    logic power_of_two;
    logic [3:0] shift_amount;
} special_flags_t;

// Pipeline registers
stage_t stage, next_stage;
reg [3:0] cnt;
reg [15:0] sr;          // {remainder, quotient}
reg [7:0] divisor_abs;
reg [7:0] dividend_abs;
reg result_sign;
reg op_valid_pipe;
special_flags_t special;

// Combinational signals
wire [7:0] dividend_twos = -dividend;
wire [7:0] divisor_twos = -divisor;
wire [8:0] sub_result = {1'b0, sr[15:8]} + {1'b0, ~divisor_abs + 1'b1};
wire carry_out = ~sub_result[8];
wire [15:0] next_sr = carry_out ? {sub_result[7:0], sr[7:0], 1'b1} : {sr[14:0], 1'b0};
wire is_power_of_two = (divisor_abs & (divisor_abs - 1)) == 0;
wire [3:0] calc_shift = 
    divisor_abs[7] ? 4'd7 :
    divisor_abs[6] ? 4'd6 :
    divisor_abs[5] ? 4'd5 :
    divisor_abs[4] ? 4'd4 :
    divisor_abs[3] ? 4'd3 :
    divisor_abs[2] ? 4'd2 :
    divisor_abs[1] ? 4'd1 : 4'd0;

// Special case handling
always_comb begin
    special.div_by_zero = (divisor == 0);
    special.power_of_two = is_power_of_two;
    special.shift_amount = calc_shift;
end

// Pipeline control
always_comb begin
    next_stage = stage;
    case (stage)
        STAGE_INPUT: if (op_valid_pipe) next_stage = STAGE_CALC;
        STAGE_CALC: begin
            if (special.div_by_zero || (special.power_of_two && cnt >= special.shift_amount))
                next_stage = STAGE_OUTPUT;
            else if (cnt == 8)
                next_stage = STAGE_OUTPUT;
        end
        STAGE_OUTPUT: if (!opn_valid) next_stage = STAGE_INPUT;
    endcase
end

// Main pipeline
always @(posedge clk or posedge rst) begin
    if (rst) begin
        stage <= STAGE_INPUT;
        cnt <= 0;
        sr <= 0;
        res_valid <= 0;
        result <= 0;
        op_valid_pipe <= 0;
    end else begin
        stage <= next_stage;
        
        case (stage)
            STAGE_INPUT: begin
                res_valid <= 0;
                if (opn_valid) begin
                    // Handle signed/unsigned conversion
                    dividend_abs <= sign & dividend[7] ? dividend_twos : dividend;
                    divisor_abs <= sign & divisor[7] ? divisor_twos : divisor;
                    result_sign <= sign & (dividend[7] ^ divisor[7]);
                    op_valid_pipe <= 1;
                end
            end
            
            STAGE_CALC: begin
                op_valid_pipe <= 0;
                
                if (special.power_of_two && cnt < special.shift_amount) begin
                    // Power-of-two fast path
                    sr <= {sr[14:0], 1'b0};
                    cnt <= cnt + 1;
                end
                else if (!special.div_by_zero && cnt < 8) begin
                    // Normal radix-2 division
                    sr <= next_sr;
                    cnt <= cnt + 1;
                end
            end
            
            STAGE_OUTPUT: begin
                res_valid <= 1;
                cnt <= 0;
                
                if (special.div_by_zero) begin
                    result <= {8'hFF, 8'hFF};  // Error code
                end else if (special.power_of_two) begin
                    // Power-of-two result
                    result <= {
                        dividend_abs & ((1 << special.shift_amount) - 1),
                        result_sign ? 
                            -(dividend_abs >> special.shift_amount) : 
                            (dividend_abs >> special.shift_amount)
                    };
                end else begin
                    // Normal result
                    result <= {
                        result_sign ? -sr[15:8] : sr[15:8],
                        result_sign ? -sr[7:0] : sr[7:0]
                    };
                end
            end
        endcase
    end
end

endmodule