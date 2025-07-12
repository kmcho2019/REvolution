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

// State machine parameters
localparam IDLE = 2'b00;
localparam CALC = 2'b01;
localparam DONE = 2'b10;

reg [1:0] state;
reg [2:0] cnt;  // 3-bit counter for 8 iterations (0-7)
reg [15:0] SR;  // Shift register [remainder|quotient]
reg [7:0] pos_divisor;
reg dividend_sign, divisor_sign;

// Continuous assignments
wire [7:0] abs_dividend = dividend_sign ? -dividend : dividend;
wire [7:0] abs_divisor = divisor_sign ? -divisor : divisor;
wire [7:0] neg_divisor = -abs_divisor;
wire division_by_zero = (abs_divisor == 0);
wire calc_done = (cnt == 3'b111);  // After 8 iterations

// Arithmetic operation signals
wire [8:0] sub_result = {1'b0, SR[15:8]} + {1'b0, neg_divisor};
wire sub_positive = ~sub_result[8];  // Carry out indicates positive result

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 0;
        SR <= 0;
        cnt <= 0;
        dividend_sign <= 0;
        divisor_sign <= 0;
        pos_divisor <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid) begin
                    dividend_sign <= sign & dividend[7];
                    divisor_sign <= sign & divisor[7];
                    pos_divisor <= divisor_sign ? -divisor : divisor;
                    
                    if (division_by_zero) begin
                        result <= {8'hFF, 8'hFF};
                        state <= DONE;
                    end else begin
                        SR <= {abs_dividend, 8'b0};
                        cnt <= 0;
                        state <= CALC;
                    end
                end
            end
            
            CALC: begin
                if (sub_positive) begin
                    SR <= {sub_result[7:0], SR[7:0], 1'b1};
                end else begin
                    SR <= {SR[14:0], 1'b0};
                end
                
                cnt <= cnt + 1;
                if (calc_done) begin
                    // Final restoration step if remainder is negative
                    if (SR[15]) begin
                        SR[15:8] <= SR[15:8] + pos_divisor;
                        SR[7:0] <= SR[7:0] - 1;
                    end
                    state <= DONE;
                end
            end
            
            DONE: begin
                // Apply final signs
                result[15:8] <= dividend_sign ? -SR[15:8] : SR[15:8];
                result[7:0] <= (dividend_sign ^ divisor_sign) ? -SR[7:0] : SR[7:0];
                res_valid <= 1;
                if (!opn_valid) state <= IDLE;
            end
        endcase
    end
end

endmodule