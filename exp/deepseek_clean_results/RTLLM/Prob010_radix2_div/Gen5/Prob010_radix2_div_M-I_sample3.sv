module radix2_div (
    input wire clk,
    input wire rst,
    input wire sign,
    input wire [7:0] dividend,
    input wire [7:0] divisor,
    input wire opn_valid,
    output logic res_valid,
    output logic [15:0] result
);

typedef enum logic {
    IDLE,
    CALCULATING
} state_t;

state_t state, next_state;
logic [3:0] cnt;
logic [15:0] SR; // {remainder, quotient}
logic dividend_sign, divisor_sign;
logic div_by_zero;
logic [7:0] divisor_abs;

// Pre-compute subtraction result
logic [8:0] sub_result;
assign sub_result = {1'b0, SR[15:8]} + {1'b0, ~divisor_abs + 1'b1};
logic carry_out;
assign carry_out = ~sub_result[8]; // Positive result means no borrow

always_comb begin
    next_state = state;
    case (state)
        IDLE: if (opn_valid && !res_valid)
            next_state = div_by_zero ? IDLE : CALCULATING;
        CALCULATING: if (cnt == 7)
            next_state = IDLE;
    endcase
end

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= '0;
        SR <= '0;
        res_valid <= 1'b0;
        result <= '0;
        dividend_sign <= 1'b0;
        divisor_sign <= 1'b0;
        div_by_zero <= 1'b0;
        divisor_abs <= '0;
    end else begin
        state <= next_state;
        res_valid <= 1'b0;

        case (state)
            IDLE: begin
                if (opn_valid && !res_valid) begin
                    dividend_sign <= sign & dividend[7];
                    divisor_sign <= sign & divisor[7];
                    divisor_abs <= (sign & divisor[7]) ? -divisor : divisor;
                    div_by_zero <= (divisor == '0);
                    
                    if (!div_by_zero) begin
                        SR <= {8'b0, (sign & dividend[7]) ? -dividend : dividend};
                        cnt <= '0;
                    end else begin
                        result <= {8'hFF, 8'hFF};
                        res_valid <= 1'b1;
                    end
                end
            end

            CALCULATING: begin
                if (carry_out) begin
                    SR <= {sub_result[7:0], SR[7:0], 1'b1};
                end else begin
                    SR <= {SR[14:0], 1'b0};
                end

                if (cnt == 7) begin
                    // Final result assembly
                    if (dividend_sign) begin
                        result[15:8] <= -SR[15:8];
                    end else begin
                        result[15:8] <= SR[15:8];
                    end

                    if (dividend_sign ^ divisor_sign) begin
                        result[7:0] <= -SR[7:0];
                    end else begin
                        result[7:0] <= SR[7:0];
                    end
                    
                    res_valid <= 1'b1;
                    cnt <= '0;
                end else begin
                    cnt <= cnt + 1;
                end
            end
        endcase
    end
end

endmodule