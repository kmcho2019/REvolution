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
localparam IDLE = 2'b00;
localparam CALC = 2'b01;
localparam DONE = 2'b10;

reg [1:0] state;
reg [2:0] step_cnt;
reg [15:0] working_reg; // {remainder, quotient}
reg [7:0] abs_divisor;
reg [7:0] neg_divisor;
reg result_sign;

// Early termination signals
wire zero_divisor = (divisor == 8'b0);
wire zero_dividend = (dividend == 8'b0);
wire early_term = zero_divisor | zero_dividend;

// Sign handling
wire dividend_sign = sign & dividend[7];
wire divisor_sign = sign & divisor[7];
wire [7:0] dividend_abs = dividend_sign ? -dividend : dividend;
wire [7:0] divisor_abs = divisor_sign ? -divisor : divisor;

// Division signals
wire [8:0] sub_result = {working_reg[15:8], 1'b0} + {1'b0, neg_divisor};
wire sub_positive = ~sub_result[8];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 0;
        working_reg <= 0;
        step_cnt <= 0;
        abs_divisor <= 0;
        neg_divisor <= 0;
        result_sign <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid) begin
                    // Pre-compute all sign-related information
                    result_sign <= dividend_sign ^ divisor_sign;
                    abs_divisor <= divisor_abs;
                    neg_divisor <= ~divisor_abs + 1'b1;
                    
                    if (early_term) begin
                        // Handle special cases immediately
                        result <= zero_divisor ? {dividend, 8'hFF} : {8'b0, 8'b0};
                        res_valid <= 1;
                        state <= DONE;
                    end else begin
                        // Initialize working registers
                        working_reg <= {8'b0, dividend_abs};
                        step_cnt <= 0;
                        state <= CALC;
                    end
                end
            end
            
            CALC: begin
                if (step_cnt == 3'd7) begin
                    // Final step - adjust remainder if negative
                    if (working_reg[15]) begin
                        working_reg[15:8] <= working_reg[15:8] + abs_divisor;
                    end
                    state <= DONE;
                end else begin
                    // Normal division step
                    if (sub_positive) begin
                        working_reg <= {sub_result[7:0], working_reg[7:0], 1'b1};
                    end else begin
                        working_reg <= {working_reg[15:8], working_reg[7:0], 1'b0};
                    end
                    step_cnt <= step_cnt + 1;
                end
            end
            
            DONE: begin
                // Apply sign correction and output result
                if (sign) begin
                    result <= {
                        dividend_sign ? -working_reg[15:8] : working_reg[15:8],
                        result_sign ? -working_reg[7:0] : working_reg[7:0]
                    };
                end else begin
                    result <= working_reg;
                end
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule