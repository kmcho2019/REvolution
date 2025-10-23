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
    DIVIDE,
    FINISH
} state_t;

reg [1:0] state;
reg [3:0] cnt;
reg [15:0] RQ;       // Combined Remainder (upper 8) and Quotient (lower 8)
reg [7:0] divisor_abs;
reg dividend_sign;
reg divisor_sign;
reg div_by_zero;
reg early_term;

// Datapath signals
wire [7:0] dividend_abs = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] divisor_twos_comp = -dividend_abs;
wire [8:0] sub_result = {RQ[15:8], 1'b0} + {divisor_abs[7], ~divisor_abs + 1'b1};
wire sub_positive = ~sub_result[8];
wire remainder_zero = (RQ[15:8] == 0);

// Next state logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        RQ <= 0;
        res_valid <= 0;
        result <= 0;
        early_term <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid && !res_valid) begin
                    dividend_sign <= sign & dividend[7];
                    divisor_sign <= sign & divisor[7];
                    divisor_abs <= (sign & divisor[7]) ? -divisor : divisor;
                    div_by_zero <= (divisor == 0);
                    RQ <= {8'b0, dividend_abs};
                    cnt <= 0;
                    early_term <= 0;
                    state <= DIVIDE;
                end
            end
            
            DIVIDE: begin
                if (remainder_zero) begin
                    early_term <= 1;
                    state <= FINISH;
                end else if (cnt == 7) begin
                    state <= FINISH;
                end else begin
                    // Non-restoring division step
                    RQ <= sub_positive ? 
                          {sub_result[7:0], RQ[7:0], 1'b1} : 
                          {RQ[14:0], 1'b0};
                    cnt <= cnt + 1;
                end
            end
            
            FINISH: begin
                res_valid <= 1;
                if (div_by_zero) begin
                    result <= {8'hFF, 8'hFF};
                end else begin
                    // Correct remainder and quotient signs
                    result <= {
                        dividend_sign ? -RQ[15:8] : RQ[15:8],
                        (dividend_sign ^ divisor_sign) ? -RQ[7:0] : RQ[7:0]
                    };
                end
                state <= IDLE;
            end
        endcase
    end
end

endmodule