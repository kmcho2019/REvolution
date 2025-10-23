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

// State machine definitions
localparam IDLE = 2'b00;
localparam CALC = 2'b01;
localparam DONE = 2'b10;

reg [1:0] state;
reg [3:0] cnt;
reg [15:0] shift_reg;
reg [7:0] abs_divisor;
reg [7:0] abs_dividend;
reg q_sign, r_sign;

// Continuous assignments
wire [7:0] neg_divisor = -abs_divisor;
wire [8:0] sub_result = {1'b0, shift_reg[15:8]} + {1'b0, neg_divisor};
wire sub_ok = ~sub_result[8];  // 1 if result is positive
wire div_by_zero = (divisor == 8'b0);

// Next state logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 16'b0;
        cnt <= 0;
        shift_reg <= 16'b0;
        q_sign <= 0;
        r_sign <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (opn_valid && !res_valid) begin
                    // Handle signed operations
                    if (sign) begin
                        q_sign <= dividend[7] ^ divisor[7];
                        r_sign <= dividend[7];
                        abs_dividend <= dividend[7] ? -dividend : dividend;
                        abs_divisor <= divisor[7] ? -divisor : divisor;
                    end else begin
                        q_sign <= 0;
                        r_sign <= 0;
                        abs_dividend <= dividend;
                        abs_divisor <= divisor;
                    end
                    
                    // Initialize shift register
                    shift_reg <= {8'b0, abs_dividend} << 1;
                    cnt <= 0;
                    state <= div_by_zero ? DONE : CALC;
                end
            end
            
            CALC: begin
                // Perform one division step
                if (sub_ok) begin
                    shift_reg <= {sub_result[7:0], shift_reg[7:1], 1'b1};
                end else begin
                    shift_reg <= {shift_reg[15:8], shift_reg[7:1], 1'b0};
                end
                
                // Check completion
                if (cnt == 7) begin
                    state <= DONE;
                end
                cnt <= cnt + 1;
            end
            
            DONE: begin
                // Final remainder adjustment
                if (!sub_ok && !div_by_zero) begin
                    shift_reg[15:8] <= shift_reg[15:8] + abs_divisor;
                end
                
                // Handle division by zero (return max values)
                if (div_by_zero) begin
                    shift_reg <= {8'hFF, 8'hFF};
                end
                // Apply sign correction
                else if (sign) begin
                    shift_reg[7:0] <= q_sign ? -shift_reg[7:0] : shift_reg[7:0];
                    shift_reg[15:8] <= r_sign ? -shift_reg[15:8] : shift_reg[15:8];
                end
                
                result <= shift_reg;
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
        
        // Clear valid when result is consumed
        if (res_valid && opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule