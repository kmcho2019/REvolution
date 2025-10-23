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
reg [1:0] stage, next_stage;
localparam STAGE_INPUT = 2'd0;
localparam STAGE_CALC = 2'd1;
localparam STAGE_OUTPUT = 2'd2;

// Special case flags
reg div_by_zero;
reg power_of_two;
reg [3:0] shift_amount;

// Pipeline registers
reg [3:0] cnt;
reg [15:0] sr;          // {remainder, quotient}
reg [7:0] divisor_abs;
reg [7:0] dividend_abs;
reg result_sign;
reg op_valid_pipe;

// Combinational signals
wire [7:0] dividend_twos = -dividend;
wire [7:0] divisor_twos = -divisor;
wire [8:0] sub_result = {1'b0, sr[15:8]} + {1'b0, ~divisor_abs + 1'b1};
wire carry_out = ~sub_result[8];
wire [15:0] next_sr = carry_out ? {sub_result[7:0], sr[7:0], 1'b1} : {sr[14:0], 1'b0};

// Special case detection
always @* begin
    div_by_zero = (divisor == 8'd0);
    power_of_two = (divisor_abs & (divisor_abs - 8'd1)) == 8'd0;
    
    if (divisor_abs[7]) shift_amount = 4'd7;
    else if (divisor_abs[6]) shift_amount = 4'd6;
    else if (divisor_abs[5]) shift_amount = 4'd5;
    else if (divisor_abs[4]) shift_amount = 4'd4;
    else if (divisor_abs[3]) shift_amount = 4'd3;
    else if (divisor_abs[2]) shift_amount = 4'd2;
    else if (divisor_abs[1]) shift_amount = 4'd1;
    else shift_amount = 4'd0;
end

// Pipeline control
always @* begin
    next_stage = stage;
    case (stage)
        STAGE_INPUT: if (op_valid_pipe) next_stage = STAGE_CALC;
        STAGE_CALC: begin
            if (div_by_zero || (power_of_two && cnt >= shift_amount))
                next_stage = STAGE_OUTPUT;
            else if (cnt == 4'd8)
                next_stage = STAGE_OUTPUT;
        end
        STAGE_OUTPUT: if (!opn_valid) next_stage = STAGE_INPUT;
    endcase
end

// Power-of-two mask calculation
function [7:0] pow2_mask;
    input [3:0] shift;
    begin
        case (shift)
            4'd0: pow2_mask = 8'h00;
            4'd1: pow2_mask = 8'h01;
            4'd2: pow2_mask = 8'h03;
            4'd3: pow2_mask = 8'h07;
            4'd4: pow2_mask = 8'h0F;
            4'd5: pow2_mask = 8'h1F;
            4'd6: pow2_mask = 8'h3F;
            4'd7: pow2_mask = 8'h7F;
            default: pow2_mask = 8'h00;
        endcase
    end
endfunction

// Main pipeline
always @(posedge clk or posedge rst) begin
    if (rst) begin
        stage <= STAGE_INPUT;
        cnt <= 4'd0;
        sr <= 16'd0;
        res_valid <= 1'b0;
        result <= 16'd0;
        op_valid_pipe <= 1'b0;
    end else begin
        stage <= next_stage;
        
        case (stage)
            STAGE_INPUT: begin
                res_valid <= 1'b0;
                if (opn_valid) begin
                    // Handle signed/unsigned conversion
                    dividend_abs <= sign & dividend[7] ? dividend_twos : dividend;
                    divisor_abs <= sign & divisor[7] ? divisor_twos : divisor;
                    result_sign <= sign & (dividend[7] ^ divisor[7]);
                    op_valid_pipe <= 1'b1;
                end
            end
            
            STAGE_CALC: begin
                op_valid_pipe <= 1'b0;
                
                if (power_of_two && cnt < shift_amount) begin
                    // Power-of-two fast path
                    sr <= {sr[14:0], 1'b0};
                    cnt <= cnt + 4'd1;
                end
                else if (!div_by_zero && cnt < 4'd8) begin
                    // Normal radix-2 division
                    sr <= next_sr;
                    cnt <= cnt + 4'd1;
                end
            end
            
            STAGE_OUTPUT: begin
                res_valid <= 1'b1;
                cnt <= 4'd0;
                
                if (div_by_zero) begin
                    result <= {8'hFF, 8'hFF};  // Error code
                end else if (power_of_two) begin
                    // Power-of-two result
                    result <= {
                        dividend_abs & pow2_mask(shift_amount),
                        result_sign ? 
                            -(dividend_abs >> shift_amount) : 
                            (dividend_abs >> shift_amount)
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