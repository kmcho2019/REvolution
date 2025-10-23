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
    IDLE,
    PREPARE,
    DIVIDE,
    FINALIZE
} state_t;

// Internal registers
reg [1:0] state;
reg [2:0] cnt;
reg [15:0] div_reg;  // {remainder[7:0], quotient[7:0]}
reg [7:0] divisor_reg;
reg dividend_sign;
reg divisor_sign;
reg div_by_zero;
reg early_done;

// Absolute value calculation
wire [7:0] abs_dividend = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] abs_divisor = (sign & divisor[7]) ? -divisor : divisor;

// Division signals
wire [8:0] sub_result = {div_reg[15:8], 1'b0} + {1'b1, ~divisor_reg + 1'b1};
wire sub_positive = ~sub_result[8];
wire [7:0] next_remainder = sub_positive ? sub_result[7:0] : {div_reg[14:8], 1'b0};
wire [7:0] next_quotient = {div_reg[6:0], sub_positive};

// Control signals
wire start_division = (state == PREPARE);
wire division_done = (cnt == 3'd7) || early_done;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        div_reg <= 0;
        res_valid <= 0;
        result <= 0;
        early_done <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid && !res_valid) begin
                    // Store signs and absolute values
                    dividend_sign <= sign & dividend[7];
                    divisor_sign <= sign & divisor[7];
                    divisor_reg <= abs_divisor;
                    div_by_zero <= (divisor == 0);
                    
                    // Initialize division register
                    div_reg <= {8'b0, abs_dividend};
                    cnt <= 0;
                    early_done <= 0;
                    state <= PREPARE;
                end
            end
            
            PREPARE: begin
                // Check for early termination cases
                if (div_by_zero) begin
                    result <= {8'hFF, 8'hFF};
                    state <= FINALIZE;
                end else if (divisor_reg > div_reg[7:0]) begin
                    // Divisor > dividend case
                    result <= {div_reg[7:0], 8'b0};
                    state <= FINALIZE;
                end else begin
                    state <= DIVIDE;
                end
            end
            
            DIVIDE: begin
                if (division_done) begin
                    state <= FINALIZE;
                end else begin
                    // Perform one division step
                    div_reg <= {next_remainder, next_quotient};
                    cnt <= cnt + 1;
                    
                    // Early exit if remainder goes to zero
                    if (next_remainder == 0)
                        early_done <= 1;
                end
            end
            
            FINALIZE: begin
                res_valid <= 1;
                if (!div_by_zero) begin
                    // Apply sign correction
                    result <= {
                        dividend_sign ? -div_reg[15:8] : div_reg[15:8],
                        (dividend_sign ^ divisor_sign) ? -div_reg[7:0] : div_reg[7:0]
                    };
                end
                state <= IDLE;
            end
        endcase
    end
end

endmodule