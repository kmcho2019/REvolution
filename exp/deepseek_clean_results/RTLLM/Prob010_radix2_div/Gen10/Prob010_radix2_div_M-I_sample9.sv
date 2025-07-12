module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg error,
    output reg [15:0] result
);

localparam IDLE = 2'b00;
localparam CALC = 2'b01;
localparam DONE = 2'b10;

reg [1:0] state;
reg [15:0] SR;    // [remainder|quotient]
reg [7:0] divisor_abs;
reg [3:0] cnt;
reg sign_q, sign_r;

wire [7:0] dividend_abs = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] divisor_abs_w = (sign & divisor[7]) ? -divisor : divisor;
wire [8:0] divisor_neg = -{1'b0, divisor_abs_w};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        SR <= 0;
        res_valid <= 0;
        error <= 0;
        result <= 0;
        cnt <= 0;
        sign_q <= 0;
        sign_r <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (opn_valid && !res_valid) begin
                    if (divisor == 0) begin
                        // Divide by zero
                        state <= DONE;
                        res_valid <= 1;
                        error <= 1;
                        result <= {8'hFF, 8'hFF};
                    end else begin
                        // Initialize division
                        SR <= {8'b0, dividend_abs};
                        divisor_abs <= divisor_abs_w;
                        sign_q <= sign & (dividend[7] ^ divisor[7]);
                        sign_r <= sign & dividend[7];
                        cnt <= 0;
                        state <= CALC;
                        res_valid <= 0;
                        error <= 0;
                    end
                end
            end
            
            CALC: begin
                if (cnt == 7) begin
                    state <= DONE;
                end
                
                // Division step
                if (SR[15:8] >= divisor_abs) begin
                    SR <= {SR[15:8] + divisor_neg[7:0], SR[7:0], 1'b1};
                end else begin
                    SR <= {SR[14:0], 1'b0};
                end
                cnt <= cnt + 1;
            end
            
            DONE: begin
                // Final result with sign correction
                result <= {
                    sign_r ? -SR[15:8] : SR[15:8],  // remainder
                    sign_q ? -SR[7:0] : SR[7:0]      // quotient
                };
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
        
        // Clear valid if new operation requested
        if (opn_valid && res_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule