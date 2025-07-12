module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

reg [7:0] remainder;
reg [7:0] quotient;
reg [7:0] neg_divisor;
reg [3:0] cnt; // Counter to track division iterations
reg start_div; // Flag to indicate division process start

// Initialize registers and flags upon reset
always @(posedge clk) begin
    if (rst) begin
        remainder <= 0;
        quotient <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_div <= 0;
        res_valid <= 0;
    end else begin
        // Initialize dividend and divisor when opn_valid is high and not in progress
        if (opn_valid && !start_div) begin
            if (divisor == 0) begin
                res_valid <= 1'b1;
                result <= {8'b0, 8'b0}; // Set result to zero for division by zero
            end else begin
                remainder <= {1'b0, dividend[7:0]}; // Shift left by one bit
                neg_divisor <= sign ? (~divisor + 1) : divisor;
                start_div <= 1'b1;
                cnt <= 1'd1;
            end
        end
        
        // Division process
        if (start_div) begin
            if (cnt < 8) begin
                if ({1'b0, remainder[7:0]} >= neg_divisor) begin
                    remainder <= {1'b0, remainder[7:0]} - neg_divisor;
                    quotient <= quotient + (1 << (8 - cnt));
                end else begin
                    remainder <= {1'b0, remainder[7:0]};
                end
                cnt <= cnt + 1'd1;
            end else begin
                res_valid <= 1'b1;
                result <= {remainder[7:0], quotient};
                start_div <= 0;
            end
        end
        
        // Reset result valid when operation is not valid
        if (res_valid && !opn_valid) begin
            res_valid <= 0;
        end
    end
end

endmodule