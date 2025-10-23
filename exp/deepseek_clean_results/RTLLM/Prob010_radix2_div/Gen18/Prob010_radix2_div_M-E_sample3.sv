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

// State machine states
typedef enum logic [1:0] {
    IDLE,
    PROCESSING,
    FINALIZE,
    DONE
} state_t;

// Internal registers
reg [1:0] state;
reg [3:0] cnt;  // 0-8 counter
reg [15:0] sr;  // {remainder[15:8], quotient[7:0]}
reg [7:0] divisor_abs;
reg [7:0] dividend_abs;
reg result_sign_q;
reg result_sign_r;
reg early_term;

// Combinational signals
wire [7:0] divisor_twos = ~divisor + 1;
wire [7:0] dividend_twos = ~dividend + 1;
wire [7:0] divisor_mux = sign & divisor[7] ? divisor_twos : divisor;
wire [7:0] dividend_mux = sign & dividend[7] ? dividend_twos : dividend;
wire div_by_zero = (divisor == 8'b0);
wire [8:0] sub_result = {sr[15:8], 1'b0} + {1'b0, ~divisor_abs, 1'b1};
wire remainder_zero = (sr[15:8] == 8'b0);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 1'b0;
        result <= 16'b0;
        cnt <= 4'b0;
        sr <= 16'b0;
        early_term <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 1'b0;
                if (opn_valid) begin
                    // Handle signed operations
                    divisor_abs <= divisor_mux;
                    dividend_abs <= dividend_mux;
                    result_sign_q <= sign & (dividend[7] ^ divisor[7]);
                    result_sign_r <= sign & dividend[7];
                    
                    if (div_by_zero) begin
                        result <= {dividend, 8'hFF};
                        res_valid <= 1'b1;
                    end else begin
                        sr <= {8'b0, dividend_mux};
                        cnt <= 4'd1;
                        state <= PROCESSING;
                        early_term <= 1'b0;
                    end
                end
            end
            
            PROCESSING: begin
                if (early_term || cnt == 4'd8) begin
                    state <= FINALIZE;
                end else begin
                    // Parallel prefix subtraction
                    if (sub_result[8]) begin  // Positive result
                        sr <= {sub_result[7:0], sr[7:1], 1'b1};
                    end else begin
                        sr <= {sr[15:8], sr[7:1], 1'b0};
                    end
                    
                    // Early termination check
                    early_term <= remainder_zero;
                    cnt <= cnt + 1;
                end
            end
            
            FINALIZE: begin
                // Final remainder adjustment if negative
                if (sr[15]) begin
                    sr[15:8] <= sr[15:8] + divisor_abs;
                end
                
                // Apply result signs if needed
                result[15:8] <= result_sign_r ? ~sr[15:8] + 1 : sr[15:8];
                result[7:0] <= result_sign_q ? ~sr[7:0] + 1 : sr[7:0];
                res_valid <= 1'b1;
                state <= DONE;
            end
            
            DONE: begin
                if (!opn_valid) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule