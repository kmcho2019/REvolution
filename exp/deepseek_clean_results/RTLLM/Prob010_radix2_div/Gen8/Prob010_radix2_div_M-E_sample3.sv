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

// Pipeline stages
typedef enum logic [1:0] {
    IDLE,
    PROCESS,
    FORMAT
} state_t;

state_t current_state, next_state;

// Stage 1 registers
reg signed [8:0] stage1_dividend;
reg signed [8:0] stage1_divisor;
reg stage1_sign;
reg stage1_valid;

// Stage 2 registers
reg [7:0] stage2_remainder;
reg [7:0] stage2_quotient;
reg [3:0] stage2_iter;
reg stage2_sign_flag;
reg stage2_div_by_zero;
reg stage2_valid;

// Division parameters
wire [7:0] abs_dividend = stage1_dividend[7] ? -stage1_dividend[7:0] : stage1_dividend[7:0];
wire [7:0] abs_divisor = stage1_divisor[7] ? -stage1_divisor[7:0] : stage1_divisor[7:0];
wire signed_operation = stage1_sign && (stage1_dividend[7] ^ stage1_divisor[7]);

// Division core signals
wire [8:0] sub_result = {1'b0, stage2_remainder} - {1'b0, abs_divisor};
wire sub_negative = sub_result[8];
wire [7:0] next_remainder = sub_negative ? stage2_remainder : sub_result[7:0];
wire [7:0] next_quotient = {stage2_quotient[6:0], ~sub_negative};

// Leading zero counter
function automatic [2:0] count_leading_zeros(input [7:0] val);
    count_leading_zeros = val[7] ? 0 : 
                         val[6] ? 1 : 
                         val[5] ? 2 : 
                         val[4] ? 3 : 
                         val[3] ? 4 : 
                         val[2] ? 5 : 
                         val[1] ? 6 : 7;
endfunction

wire [2:0] divisor_leading_zeros = count_leading_zeros(abs_divisor);
wire [3:0] max_iter = 4'd7 - {1'b0, divisor_leading_zeros};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        current_state <= IDLE;
        stage1_valid <= 0;
        stage2_valid <= 0;
        res_valid <= 0;
    end else begin
        current_state <= next_state;
        
        // Stage 1: Input processing
        if (opn_valid && current_state == IDLE) begin
            stage1_dividend <= sign ? $signed(dividend) : {1'b0, dividend};
            stage1_divisor <= sign ? $signed(divisor) : {1'b0, divisor};
            stage1_sign <= sign;
            stage1_valid <= 1;
        end else begin
            stage1_valid <= 0;
        end
        
        // Stage 2: Division core
        if (current_state == PROCESS) begin
            if (!stage2_valid) begin
                // Initialize
                stage2_remainder <= abs_dividend;
                stage2_quotient <= 0;
                stage2_iter <= 0;
                stage2_sign_flag <= signed_operation;
                stage2_div_by_zero <= (abs_divisor == 0);
                stage2_valid <= 1;
            end else if (stage2_iter < max_iter && stage2_remainder != 0) begin
                // Iteration
                stage2_remainder <= next_remainder;
                stage2_quotient <= next_quotient;
                stage2_iter <= stage2_iter + 1;
            end
        end else begin
            stage2_valid <= 0;
        end
        
        // Stage 3: Result formatting
        if (current_state == FORMAT) begin
            if (stage2_div_by_zero) begin
                result <= 16'hFFFF; // Error code for division by zero
            end else begin
                result <= {stage1_dividend[7] ? -stage2_remainder : stage2_remainder,
                          stage2_sign_flag ? -stage2_quotient : stage2_quotient};
            end
            res_valid <= 1;
        end else begin
            res_valid <= 0;
        end
    end
end

// State machine
always_comb begin
    case (current_state)
        IDLE: next_state = (opn_valid) ? PROCESS : IDLE;
        PROCESS: begin
            if (stage2_div_by_zero || (stage2_valid && (stage2_iter == max_iter || stage2_remainder == 0)))
                next_state = FORMAT;
            else
                next_state = PROCESS;
        end
        FORMAT: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

endmodule