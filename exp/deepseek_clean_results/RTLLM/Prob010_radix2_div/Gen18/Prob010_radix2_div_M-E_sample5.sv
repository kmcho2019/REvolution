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

// States
localparam IDLE = 0;
localparam CALC = 1;
localparam DONE = 2;

reg [1:0] state;
reg [3:0] cnt;
reg [15:0] acc;  // {remainder, quotient}
reg [7:0] pos_divisor;
reg [7:0] neg_divisor;
reg q_sign, r_sign;
reg div_by_zero;

// Absolute values
wire [7:0] abs_dividend = sign & dividend[7] ? -dividend : dividend;
wire [7:0] abs_divisor = sign & divisor[7] ? -divisor : divisor;

// Subtraction result
wire [8:0] sub_res = {1'b0, acc[15:8]} + {1'b0, neg_divisor};
wire sub_ok = ~sub_res[8];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        acc <= 0;
        div_by_zero <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid) begin
                    // Handle divide by zero
                    div_by_zero <= (divisor == 0);
                    
                    // Calculate signs
                    q_sign <= sign & (dividend[7] ^ divisor[7]);
                    r_sign <= sign & dividend[7];
                    
                    // Store absolute values
                    pos_divisor <= abs_divisor;
                    neg_divisor <= -abs_divisor;
                    
                    // Initialize accumulator
                    acc <= {8'b0, abs_dividend};
                    cnt <= 0;
                    
                    if (divisor == 0) begin
                        // Special case: divide by zero
                        result <= {dividend, 8'hFF};
                        res_valid <= 1;
                    end else begin
                        state <= CALC;
                    end
                end
            end
            
            CALC: begin
                if (cnt == 8) begin
                    state <= DONE;
                end else begin
                    // Non-restoring division step
                    if (sub_ok) begin
                        acc <= {sub_res[7:0], acc[6:0], 1'b1};
                    end else begin
                        acc <= {acc[14:0], 1'b0};
                    end
                    
                    cnt <= cnt + 1;
                    
                    // Early termination if remainder is zero
                    if (acc[15:8] == 0) begin
                        state <= DONE;
                    end
                end
            end
            
            DONE: begin
                // Correct remainder if negative
                if (acc[15]) begin
                    acc[15:8] <= acc[15:8] + pos_divisor;
                end
                
                // Apply signs
                result[15:8] <= r_sign ? -acc[15:8] : acc[15:8];  // remainder
                result[7:0] <= q_sign ? -acc[7:0] : acc[7:0];     // quotient
                
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule