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

// Internal registers
reg [7:0] Q;        // Quotient
reg [7:0] R;        // Remainder
reg [7:0] D;        // Divisor (absolute value)
reg [3:0] cnt;      // Iteration counter
reg running;        // Division in progress
reg q_sign, r_sign; // Result signs
reg div_by_zero;

// Combinational signals
wire [7:0] abs_divisor = (sign & divisor[7]) ? (~divisor + 1) : divisor;
wire [7:0] abs_dividend = (sign & dividend[7]) ? (~dividend + 1) : dividend;
wire [8:0] sub_result = {R, 1'b0} + {1'b0, ~D, 1'b1}; // R*2 - D
wire remainder_zero = (R == 8'b0);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
        result <= 16'b0;
        cnt <= 4'b0;
        running <= 1'b0;
        Q <= 8'b0;
        R <= 8'b0;
        D <= 8'b0;
        div_by_zero <= 1'b0;
    end else begin
        if (opn_valid && !running && !res_valid) begin
            // Initialize division
            D <= abs_divisor;
            R <= 8'b0;
            Q <= abs_dividend;
            cnt <= 4'd0;
            running <= 1'b1;
            res_valid <= 1'b0;
            
            // Compute result signs
            q_sign <= sign & (dividend[7] ^ divisor[7]);
            r_sign <= sign & dividend[7];
            div_by_zero <= (divisor == 8'b0);
        end
        
        if (running) begin
            if (div_by_zero) begin
                // Handle division by zero
                result <= {dividend, 8'hFF};
                res_valid <= 1'b1;
                running <= 1'b0;
            end else if (remainder_zero && cnt != 0) begin
                // Early termination if remainder is zero
                result <= {r_sign ? (~R + 1) : R, q_sign ? (~Q + 1) : Q};
                res_valid <= 1'b1;
                running <= 1'b0;
            end else if (cnt == 4'd8) begin
                // Final iteration
                if (R[7]) begin
                    // Correct negative remainder
                    R <= R + D;
                end
                
                // Format final result with correct signs
                result <= {r_sign ? (~R + 1) : R, q_sign ? (~Q + 1) : Q};
                res_valid <= 1'b1;
                running <= 1'b0;
            end else begin
                // Normal iteration
                if (sub_result[8]) begin
                    // Subtraction successful
                    R <= sub_result[7:0];
                    Q <= {Q[6:0], 1'b1};
                end else begin
                    // Subtraction failed
                    Q <= {Q[6:0], 1'b0};
                end
                cnt <= cnt + 1;
            end
        end else if (res_valid && !opn_valid) begin
            // Ready for new operation
            res_valid <= 1'b0;
        end
    end
end

endmodule