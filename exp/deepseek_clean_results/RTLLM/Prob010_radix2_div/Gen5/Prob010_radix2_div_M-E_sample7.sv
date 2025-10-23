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

// Internal state machine
typedef enum logic [1:0] {
    IDLE,
    PREPROCESS,
    DIVIDE,
    POSTPROCESS
} state_t;

// Internal registers
state_t state;
reg [7:0] dividend_reg, divisor_reg;
reg [15:0] partial;  // {remainder, quotient}
reg [2:0] cnt;
reg q_sign, r_sign;
reg div_by_zero;
reg trivial_case;
reg input_valid;

// Datapath signals
wire [8:0] sub_res_hi = {1'b0, partial[15:8]} - {1'b0, divisor_reg};
wire [8:0] sub_res_lo = {1'b0, partial[15:8]} - {1'b0, divisor_reg[7:1]};
wire borrow_hi = sub_res_hi[8];
wire borrow_lo = sub_res_lo[8];
wire [7:0] next_rem_hi = borrow_hi ? partial[15:8] : sub_res_hi[7:0];
wire [7:0] next_rem_lo = borrow_lo ? partial[15:8] : sub_res_lo[7:0];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 0;
        partial <= 0;
        cnt <= 0;
        q_sign <= 0;
        r_sign <= 0;
        div_by_zero <= 0;
        trivial_case <= 0;
        input_valid <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid) begin
                    // Handle signs and special cases
                    q_sign <= sign & (dividend[7] ^ divisor[7]);
                    r_sign <= sign & dividend[7];
                    dividend_reg <= sign & dividend[7] ? -dividend : dividend;
                    divisor_reg <= sign & divisor[7] ? -divisor : divisor;
                    div_by_zero <= (divisor == 0);
                    trivial_case <= (sign ? $signed(dividend) : dividend) < 
                                   (sign ? $signed(divisor) : divisor);
                    state <= PREPROCESS;
                end
            end
            
            PREPROCESS: begin
                if (div_by_zero) begin
                    // Handle division by zero (quotient = max, remainder = dividend)
                    partial <= {dividend_reg, 8'hFF};
                    state <= POSTPROCESS;
                end else if (trivial_case) begin
                    // Dividend < divisor case
                    partial <= {dividend_reg, 8'h00};
                    state <= POSTPROCESS;
                end else begin
                    // Initialize division
                    partial <= {8'b0, dividend_reg};
                    cnt <= 0;
                    state <= DIVIDE;
                end
            end
            
            DIVIDE: begin
                if (cnt == 3'd4) begin
                    state <= POSTPROCESS;
                end else begin
                    // Process 2 bits per cycle (radix-4 style)
                    // First bit
                    partial[15:8] <= {next_rem_hi[6:0], partial[7]};
                    partial[7:0] <= {partial[6:0], ~borrow_hi};
                    
                    // Second bit
                    partial[15:8] <= {next_rem_lo[6:0], partial[7]};
                    partial[7:0] <= {partial[6:0], ~borrow_lo};
                    
                    cnt <= cnt + 1;
                end
            end
            
            POSTPROCESS: begin
                // Final remainder adjustment
                if (partial[15]) begin
                    partial[15:8] <= partial[15:8] + divisor_reg;
                end
                
                // Apply sign correction
                if (sign) begin
                    partial[7:0] <= q_sign ? -partial[7:0] : partial[7:0];
                    partial[15:8] <= r_sign ? -partial[15:8] : partial[15:8];
                end
                
                result <= partial;
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule