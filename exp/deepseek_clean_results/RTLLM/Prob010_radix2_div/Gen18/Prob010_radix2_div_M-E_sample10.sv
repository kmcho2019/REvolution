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
reg [3:0] cnt;
reg [15:0] sr;          // Shift register [rem|quot]
reg [7:0] divisor_reg;
reg [7:0] neg_divisor;
reg signed_op;
reg processing;
reg early_term;
reg div_by_zero;

// Absolute value computation
wire [7:0] abs_dividend = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] abs_divisor = (sign & divisor[7]) ? -divisor : divisor;

// Subtraction logic with carry-save
wire [8:0] sub_result = {1'b0, sr[15:8]} + {1'b0, neg_divisor};
wire sub_positive = ~sub_result[8];
wire remainder_zero = (sr[15:8] == 0);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        cnt <= 0;
        sr <= 0;
        divisor_reg <= 0;
        neg_divisor <= 0;
        signed_op <= 0;
        processing <= 0;
        early_term <= 0;
        div_by_zero <= 0;
    end else begin
        // Operation handshaking
        if (res_valid && !opn_valid) begin
            res_valid <= 0;  // Clear valid when result is consumed
        end
        
        // New operation start
        if (opn_valid && !processing && !res_valid) begin
            div_by_zero <= (divisor == 0);
            signed_op <= sign;
            
            if (divisor == 0) begin
                // Handle divide by zero
                result <= {dividend, 8'hFF};
                res_valid <= 1;
            end else begin
                // Initialize registers
                sr <= {8'b0, abs_dividend};
                divisor_reg <= abs_divisor;
                neg_divisor <= ~abs_divisor + 1'b1;
                cnt <= 0;
                processing <= 1;
                early_term <= 0;
            end
        end
        
        // Division processing
        if (processing) begin
            if (early_term || cnt == 4'd8) begin
                // Finalize result
                if (signed_op) begin
                    // Apply sign correction
                    result[15:8] <= (dividend[7]) ? -sr[15:8] : sr[15:8];
                    result[7:0] <= (dividend[7] ^ divisor_reg[7]) ? -sr[7:0] : sr[7:0];
                end else begin
                    result <= sr;
                end
                res_valid <= 1;
                processing <= 0;
            end else if (!early_term) begin
                // Normal iteration
                if (sub_positive) begin
                    sr <= {sub_result[7:0], sr[7:1], 1'b1};
                end else begin
                    sr <= {sr[14:0], 1'b0};
                end
                
                // Check for early termination
                early_term <= remainder_zero;
                cnt <= cnt + 1;
            end
        end
    end
end

endmodule