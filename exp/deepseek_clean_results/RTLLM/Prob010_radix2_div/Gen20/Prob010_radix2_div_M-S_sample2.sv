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

reg busy;
reg [2:0] step;
reg [15:0] sr;  // [remainder|quotient]
reg dividend_sign;
reg divisor_sign;

wire [7:0] abs_dividend = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] abs_divisor = (sign & divisor[7]) ? -divisor : divisor;
wire [7:0] neg_divisor = -abs_divisor;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
        busy <= 0;
        step <= 0;
        sr <= 0;
    end else begin
        // Clear valid when not processing
        if (res_valid && !opn_valid) begin
            res_valid <= 0;
        end
        
        // Start new operation
        if (opn_valid && !busy) begin
            if (divisor == 0) begin
                // Divide by zero case
                result <= {dividend, 8'hFF};
                res_valid <= 1;
            end else begin
                // Initialize division
                sr <= {8'b0, abs_dividend};
                dividend_sign <= sign & dividend[7];
                divisor_sign <= sign & divisor[7];
                step <= 0;
                busy <= 1;
                res_valid <= 0;
            end
        end
        
        // Division steps
        if (busy) begin
            // Perform subtraction and shift
            if ({sr[14:8], 1'b0} + neg_divisor >= 0) begin
                sr <= {sr[14:8] + neg_divisor, sr[7:0], 1'b1};
            end else begin
                sr <= {sr[14:0], 1'b0};
            end
            
            // Check completion
            if (step == 3'd7) begin
                // Finalize result with sign correction
                if (sign) begin
                    result[15:8] <= (dividend_sign ^ divisor_sign) ? -sr[15:8] : sr[15:8];
                    result[7:0] <= (dividend_sign ^ divisor_sign) ? -sr[7:0] : sr[7:0];
                end else begin
                    result <= {sr[15:8], sr[7:0]};
                end
                res_valid <= 1;
                busy <= 0;
            end else begin
                step <= step + 1;
            end
        end
    end
end

endmodule