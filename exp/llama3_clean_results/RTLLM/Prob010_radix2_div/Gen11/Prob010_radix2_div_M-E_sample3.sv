module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

// Define the pipeline stages
enum logic [2:0] {IDLE, NORMALIZE, DIVIDE, RESULT} state, next_state;

// Internal signals
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [15:0] shift_reg;
reg [3:0] cnt;
reg start_cnt;

// Input Stage
reg [7:0] norm_dividend;
reg [7:0] norm_divisor;

// Division Stage
reg [15:0] div_result;
reg [7:0] remainder;

// Result Stage
reg [15:0] final_result;

// State register
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        cnt <= 0;
        start_cnt <= 0;
        dividend_reg <= 0;
        divisor_reg <= 0;
        shift_reg <= 0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (opn_valid) begin
                    dividend_reg <= sign? {{7{dividend[7]}}, dividend[7:0]} : {8'b0, dividend};
                    divisor_reg <= sign? {{7{divisor[7]}}, divisor[7:0]} : divisor;
                    norm_dividend <= dividend_reg;
                    norm_divisor <= divisor_reg;
                    cnt <= 0;
                    start_cnt <= 1;
                    res_valid <= 0;
                end
            end
            NORMALIZE: begin
                if (divisor_reg[7] == 0) begin
                    norm_divisor <= {norm_divisor[6:0], 1'b0};
                    norm_dividend <= {norm_dividend[6:0], 1'b0};
                end else begin
                    next_state <= DIVIDE;
                end
            end
            DIVIDE: begin
                if (cnt == 8) begin
                    next_state <= RESULT;
                end else begin
                    if (norm_dividend >= norm_divisor) begin
                        div_result <= {div_result[14:0], 1'b1};
                        norm_dividend <= norm_dividend - norm_divisor;
                    end else begin
                        div_result <= {div_result[14:0], 1'b0};
                    end
                    norm_dividend <= {norm_dividend[6:0], 1'b0};
                    cnt <= cnt + 1;
                end
            end
            RESULT: begin
                remainder <= norm_dividend;
                final_result <= {remainder, div_result};
                res_valid <= 1;
                next_state <= IDLE;
            end
            default: next_state <= IDLE;
        endcase
    end
end

// Output logic
always @(posedge clk) begin
    if (state == RESULT) begin
        result <= final_result;
    end
end

endmodule