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
localparam IDLE = 0;
localparam CALC = 1;
localparam DONE = 2;

reg [1:0] state;
reg [2:0] cnt;  // 3-bit counter (0-7)
reg [15:0] sr;  // {remainder, quotient}
reg [7:0] divisor_mag;
reg [7:0] neg_divisor;
reg q_sign, r_sign;
reg div_by_zero;
reg early_term;

// Sign preprocessing
wire [7:0] dividend_mag = sign & dividend[7] ? -dividend : dividend;
wire [7:0] divisor_mag = sign & divisor[7] ? -divisor : divisor;

// Parallel-prefix subtraction
wire [8:0] sub_res = {1'b0, sr[15:8]} + {1'b0, neg_divisor};
wire sub_ok = ~sub_res[8];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        sr <= 0;
        div_by_zero <= 0;
        early_term <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid && !res_valid) begin
                    // Handle divide by zero immediately
                    if (divisor == 0) begin
                        result <= {dividend, 8'hFF};
                        res_valid <= 1;
                    end else begin
                        // Store magnitude and signs
                        divisor_mag <= divisor_mag;
                        neg_divisor <= -divisor_mag;
                        q_sign <= sign & (dividend[7] ^ divisor[7]);
                        r_sign <= sign & dividend[7];
                        
                        // Initialize shift register
                        sr <= {8'b0, dividend_mag};
                        cnt <= 0;
                        div_by_zero <= 0;
                        early_term <= 0;
                        state <= CALC;
                    end
                end
            end
            
            CALC: begin
                if (early_term || cnt == 3'd7) begin
                    state <= DONE;
                end else begin
                    // Parallel-prefix subtraction and shift
                    if (sub_ok) begin
                        sr <= {sub_res[7:0], sr[7:1], 1'b1};
                    end else begin
                        sr <= {sr[14:0], 1'b0};
                    end
                    
                    // Early termination if remainder goes to zero
                    early_term <= (sr[15:8] == 0);
                    cnt <= cnt + 1;
                end
            end
            
            DONE: begin
                // Final remainder adjustment
                if (!sub_ok && !early_term) begin
                    sr[15:8] <= sr[15:8] + divisor_mag;
                end
                
                // Apply sign correction
                result[15:8] <= r_sign ? -sr[15:8] : sr[15:8];
                result[7:0] <= q_sign ? -sr[7:0] : sr[7:0];
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule