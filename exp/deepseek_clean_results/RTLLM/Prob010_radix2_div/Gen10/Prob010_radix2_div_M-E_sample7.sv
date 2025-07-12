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
typedef enum logic [1:0] {
    IDLE,
    CALC,
    DONE
} state_t;

state_t state;
reg [3:0] cnt;        // 0-7 counter
reg [15:0] acc;       // Accumulator: {remainder, quotient}
reg [7:0] divisor_reg;
reg dividend_neg, divisor_neg;
reg early_term;
reg div_by_zero;
reg min_case;         // Handle -128/-1 special case

// Absolute values
wire [7:0] dividend_abs = sign & dividend[7] ? -dividend : dividend;
wire [7:0] divisor_abs = sign & divisor[7] ? -divisor : divisor;

// Early termination condition
wire terminate_early = (acc[15:8] < divisor_abs) && (cnt != 0);

// Non-restoring division step
wire [8:0] sub_result = {acc[15:8], 1'b0} + {1'b0, ~divisor_abs + 1'b1};
wire carry_out = ~sub_result[8];  // 1 if result positive
wire [15:0] next_acc = carry_out ? 
    {sub_result[7:0], acc[7:0], 1'b1} : 
    {acc[14:0], 1'b0};

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        cnt <= 0;
        acc <= 0;
        res_valid <= 0;
        result <= 0;
        dividend_neg <= 0;
        divisor_neg <= 0;
        early_term <= 0;
        div_by_zero <= 0;
        min_case <= 0;
    end else begin
        case (state)
            IDLE: begin
                res_valid <= 0;
                if (opn_valid && !res_valid) begin
                    // Handle special cases
                    div_by_zero <= (divisor == 0);
                    min_case <= sign && (dividend == 8'h80) && (divisor == 8'hFF);
                    
                    // Store signs
                    dividend_neg <= sign & dividend[7];
                    divisor_neg <= sign & divisor[7];
                    
                    // Initialize registers
                    divisor_reg <= divisor_abs;
                    acc <= {8'b0, dividend_abs};
                    cnt <= 0;
                    early_term <= 0;
                    
                    state <= CALC;
                end
            end
            
            CALC: begin
                if (div_by_zero || min_case) begin
                    // Handle special cases immediately
                    result <= div_by_zero ? 16'hFFFF : 
                             min_case ? {8'h00, 8'h80}; // -128/-1 = -128
                    state <= DONE;
                end else if (terminate_early) begin
                    // Early termination when divisor > remainder
                    early_term <= 1;
                    state <= DONE;
                end else if (cnt == 4'd7) begin
                    // Final iteration
                    acc <= next_acc;
                    state <= DONE;
                end else begin
                    // Normal iteration
                    acc <= next_acc;
                    cnt <= cnt + 1;
                end
            end
            
            DONE: begin
                if (!early_term && !div_by_zero && !min_case) begin
                    // Final result adjustment for non-restoring
                    if (acc[15]) begin
                        acc[15:8] <= acc[15:8] + divisor_reg;
                    end
                end
                
                // Apply signs
                if (!div_by_zero && !min_case) begin
                    result <= {
                        dividend_neg ? -acc[15:8] : acc[15:8],  // remainder
                        (dividend_neg ^ divisor_neg) ? -acc[7:0] : acc[7:0]  // quotient
                    };
                end
                
                res_valid <= 1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule