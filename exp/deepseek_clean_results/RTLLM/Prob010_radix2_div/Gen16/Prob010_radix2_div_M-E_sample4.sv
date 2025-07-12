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
localparam IDLE = 2'b00;
localparam PROCESS = 2'b01;
localparam FINISH = 2'b10;

reg [1:0] state;
reg [2:0] cnt;
reg [15:0] shift_reg;  // [remainder|quotient]
reg quotient_sign;
reg divide_by_zero;
reg [7:0] divisor_abs;
reg [7:0] dividend_abs;

// Absolute value calculation
wire [7:0] abs_dividend = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] abs_divisor = (sign & divisor[7]) ? -divisor : divisor;

// Subtraction result
wire [8:0] sub_result = {shift_reg[15:8]} + {1'b0, ~divisor_abs + 1'b1};
wire sub_positive = ~sub_result[8];

// Control signals
wire op_start = (state == IDLE) & opn_valid & ~res_valid;
wire process_done = (cnt == 3'd7);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        shift_reg <= 0;
        quotient_sign <= 0;
        divide_by_zero <= 0;
        divisor_abs <= 0;
        dividend_abs <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (op_start) begin
                    divide_by_zero <= (divisor == 0);
                    quotient_sign <= sign & (dividend[7] ^ divisor[7]);
                    divisor_abs <= abs_divisor;
                    dividend_abs <= abs_dividend;
                    
                    if (divisor == 0) begin
                        result <= {dividend, 8'hFF};  // Divide by zero result
                        res_valid <= 1;
                    end else begin
                        shift_reg <= {8'b0, abs_dividend};
                        cnt <= 0;
                        state <= PROCESS;
                    end
                end
            end
            
            PROCESS: begin
                if (process_done) begin
                    state <= FINISH;
                end else begin
                    // Non-restoring division step
                    if (sub_positive) begin
                        shift_reg <= {sub_result[7:0], shift_reg[7:1], 1'b1};
                    end else begin
                        shift_reg <= {shift_reg[14:0], 1'b0};
                    end
                    cnt <= cnt + 1;
                end
            end
            
            FINISH: begin
                // Final remainder adjustment for non-restoring
                if (~sub_positive) begin
                    shift_reg[15:8] <= shift_reg[15:8] + divisor_abs;
                end
                
                // Apply signs if needed
                result[15:8] <= (sign & dividend[7]) ? -shift_reg[15:8] : shift_reg[15:8];
                result[7:0] <= quotient_sign ? -shift_reg[7:0] : shift_reg[7:0];
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule