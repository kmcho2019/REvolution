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

// Parameters
localparam WIDTH = 8;
localparam ITERATIONS = 3'd7; // 0-7 = 8 iterations
localparam IDLE = 2'b00;
localparam CALC = 2'b01;
localparam DONE = 2'b10;

// Internal signals
reg [1:0] state;
reg [2:0] cnt;
reg [15:0] SR;  // {remainder, quotient}
reg [7:0] pos_divisor;
reg dividend_sign, divisor_sign;
wire division_by_zero;

// Continuous assignments
assign division_by_zero = (divisor == 0);

// Arithmetic operations
wire [8:0] sub_result = {1'b0, SR[15:8]} + {1'b0, -pos_divisor};
wire sub_positive = ~sub_result[8];  // Negative if carry out is 1

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
                        result <= {8'hFF, 8'hFF}; // Error value
                        state <= DONE;
                    end else begin
                        SR <= {(sign & dividend[7]) ? -dividend : dividend, 8'b0};
                        cnt <= 0;
                        state <= CALC;
                    end
                end
            end
            
            CALC: begin
                if (sub_positive) begin
                    SR <= {sub_result[7:0], SR[7:1], 1'b1};
                end else begin
                    SR <= {SR[14:0], 1'b0};
                end
                
                if (cnt == ITERATIONS) begin
                    // Final correction for negative remainder
                    if (SR[15]) begin
                        SR[15:8] <= SR[15:8] + pos_divisor;
                        SR[7:0] <= SR[7:0] - 1;
                    end
                    state <= DONE;
                end else begin
                    cnt <= cnt + 1;
                end
                
                // Handle early opn_valid deassertion
                if (!opn_valid) begin
                    state <= IDLE;
                    res_valid <= 0;
                end
            end
            
            DONE: begin
                // Apply final signs
                if (sign) begin
                    result[15:8] <= dividend_sign ? -SR[15:8] : SR[15:8];
                    result[7:0] <= (dividend_sign ^ divisor_sign) ? -SR[7:0] : SR[7:0];
                end else begin
                    result <= SR;
                end
                
                res_valid <= 1;
                if (!opn_valid) state <= IDLE;
            end
        endcase
    end
end

endmodule