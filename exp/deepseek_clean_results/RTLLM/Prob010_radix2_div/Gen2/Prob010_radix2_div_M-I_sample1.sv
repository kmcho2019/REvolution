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

// FSM states
localparam IDLE = 2'b00;
localparam CALC = 2'b01;
localparam DONE = 2'b10;

reg [1:0] state;
reg [2:0] cnt;  // Reduced from 4 bits since we only count to 8
reg [15:0] SR;  // Shift register
reg [7:0] NEG_DIVISOR;
reg quotient_sign;
reg remainder_sign;

// Combinational absolute value and sign calculation
wire [7:0] abs_dividend = sign & dividend[7] ? -dividend : dividend;
wire [7:0] abs_divisor = sign & divisor[7] ? -divisor : divisor;
wire [8:0] sub_result = {SR[15:8], 1'b0} + {1'b0, NEG_DIVISOR};
wire carry_out = sub_result[8];

// Early termination signals
wire divisor_is_zero = (divisor == 8'b0);
wire divisor_is_one = (abs_divisor == 8'd1);
wire dividend_is_zero = (dividend == 8'b0);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 3'd0;
        SR <= 16'd0;
        result <= 16'd0;
        res_valid <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 1'b0;
                if (opn_valid && !res_valid) begin
                    // Handle trivial cases immediately
                    if (divisor_is_zero || dividend_is_zero) begin
                        result <= {8'b0, 8'b0};
                        res_valid <= 1'b1;
                        state <= DONE;
                    end else if (divisor_is_one) begin
                        if (sign) begin
                            quotient_sign <= dividend[7] ^ divisor[7];
                            remainder_sign <= dividend[7];
                            result <= {dividend[7] ? -8'd0 : 8'd0, 
                                      quotient_sign ? -dividend : dividend};
                        end else begin
                            result <= {8'd0, dividend};
                        end
                        res_valid <= 1'b1;
                        state <= DONE;
                    end else begin
                        // Initialize division
                        NEG_DIVISOR <= -abs_divisor;
                        SR <= {8'd0, abs_dividend} << 1;
                        cnt <= 3'd1;
                        
                        // Pre-calculate result signs
                        quotient_sign <= sign & (dividend[7] ^ divisor[7]);
                        remainder_sign <= sign & dividend[7];
                        
                        state <= CALC;
                    end
                end
            end
            
            CALC: begin
                if (cnt[2]) begin  // cnt == 4'b100 (8)
                    // Final remainder adjustment
                    if (SR[15]) begin
                        SR[15:8] <= SR[15:8] + abs_divisor;
                    end
                    
                    // Apply sign correction
                    if (sign) begin
                        SR[7:0] <= quotient_sign ? -SR[7:0] : SR[7:0];
                        SR[15:8] <= remainder_sign ? -SR[15:8] : SR[15:8];
                    end
                    
                    result <= SR;
                    res_valid <= 1'b1;
                    state <= DONE;
                end else begin
                    // Division step
                    cnt <= cnt + 1;
                    if (carry_out) begin
                        SR <= {sub_result[7:0], SR[7:1], 1'b1};
                    end else begin
                        SR <= {SR[14:0], 1'b0};
                    end
                end
            end
            
            DONE: begin
                if (opn_valid) begin
                    res_valid <= 1'b0;
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule