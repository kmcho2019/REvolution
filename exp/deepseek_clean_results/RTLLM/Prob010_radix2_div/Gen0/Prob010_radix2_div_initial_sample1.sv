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

reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg sign_reg;
reg [15:0] SR;          // Shift register: [remainder|quotient]
reg [7:0] NEG_DIVISOR;   // Negative of absolute divisor
reg [3:0] cnt;           // Counter (0-8)
reg start_cnt;           // Division in progress
reg [1:0] state;         // State machine

// Absolute value calculation
wire [7:0] abs_dividend = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] abs_divisor = (sign & divisor[7]) ? -divisor : divisor;

// Subtraction result and carry
wire [8:0] sub_result = {SR[15:8], 1'b0} + {NEG_DIVISOR, 1'b0};
wire carry_out = ~sub_result[8];  // 1 if positive result

always @(posedge clk or posedge rst) begin
    if (rst) begin
        SR <= 16'b0;
        cnt <= 4'b0;
        start_cnt <= 1'b0;
        res_valid <= 1'b0;
        state <= 2'b0;
        dividend_reg <= 8'b0;
        divisor_reg <= 8'b0;
        sign_reg <= 1'b0;
    end else begin
        case (state)
            2'b00: begin  // Idle
                res_valid <= 1'b0;
                if (opn_valid && !res_valid) begin
                    dividend_reg <= dividend;
                    divisor_reg <= divisor;
                    sign_reg <= sign;
                    SR <= {8'b0, abs_dividend} << 1;
                    NEG_DIVISOR <= -abs_divisor;
                    cnt <= 4'b1;
                    start_cnt <= 1'b1;
                    state <= 2'b01;
                end
            end
            
            2'b01: begin  // Division in progress
                if (start_cnt) begin
                    if (cnt[3]) begin  // cnt == 8
                        // Final remainder adjustment
                        if (SR[15]) begin
                            SR[15:8] <= SR[15:8] + abs_divisor;
                        end
                        
                        // Handle sign correction
                        if (sign_reg) begin
                            // Quotient sign: dividend_sign XOR divisor_sign
                            if ((dividend_reg[7] ^ divisor_reg[7])) begin
                                SR[7:0] <= -SR[7:0];
                            end
                            // Remainder sign: dividend_sign
                            if (dividend_reg[7]) begin
                                SR[15:8] <= -SR[15:8];
                            end
                        end
                        
                        result <= SR;
                        res_valid <= 1'b1;
                        start_cnt <= 1'b0;
                        state <= 2'b10;
                    end else begin
                        // Shift and subtract
                        SR <= {sub_result[7:0], SR[7:1], carry_out};
                        cnt <= cnt + 1;
                    end
                end
            end
            
            2'b10: begin  // Result ready
                if (!opn_valid) begin
                    state <= 2'b00;
                end
            end
        endcase
    end
end

endmodule