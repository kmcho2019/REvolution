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

// State machine definitions
localparam IDLE = 2'b00;
localparam PROCESS = 2'b01;
localparam FINAL = 2'b10;

reg [1:0] state;
reg [3:0] cnt;
reg [15:0] sr;
reg [7:0] abs_divisor;
reg [7:0] neg_divisor;
reg dividend_sign;
reg divisor_sign;
reg divide_by_zero;

// Sign handling unit
always @(*) begin
    dividend_sign = sign & dividend[7];
    divisor_sign = sign & divisor[7];
    divide_by_zero = (divisor == 8'b0);
end

// Main state machine
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        sr <= 0;
        res_valid <= 0;
        result <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid && !divide_by_zero) begin
                    // Pre-process inputs
                    abs_divisor <= divisor_sign ? -divisor : divisor;
                    neg_divisor <= -(divisor_sign ? -divisor : divisor);
                    sr <= {8'b0, (dividend_sign ? -dividend : dividend)} << 1;
                    cnt <= 1;
                    state <= PROCESS;
                end else if (opn_valid && divide_by_zero) begin
                    // Handle divide by zero case
                    result <= {8'b0, 8'hFF}; // Max quotient for divide by zero
                    res_valid <= 1;
                end
            end
            
            PROCESS: begin
                // Non-restoring division step
                sr[15:8] <= sr[15] ? (sr[15:8] + abs_divisor) : 
                                    (sr[15:8] + neg_divisor);
                sr <= {sr[14:0], ~sr[15]};
                
                if (cnt == 8) begin
                    state <= FINAL;
                end
                cnt <= cnt + 1;
            end
            
            FINAL: begin
                // Final remainder adjustment
                if (sr[15]) sr[15:8] <= sr[15:8] + abs_divisor;
                
                // Apply signs if needed
                reg [7:0] final_quotient = {sr[6:0], ~sr[15]};
                reg [7:0] final_remainder = sr[15:8];
                
                if (sign) begin
                    final_quotient = (dividend_sign ^ divisor_sign) ? 
                                   -final_quotient : final_quotient;
                    final_remainder = dividend_sign ? 
                                     -final_remainder : final_remainder;
                end
                
                result <= {final_remainder, final_quotient};
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule