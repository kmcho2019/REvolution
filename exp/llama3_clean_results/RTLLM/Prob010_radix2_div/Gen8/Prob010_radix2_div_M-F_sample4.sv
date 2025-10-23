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

reg [15:0] sr; // Shift register
reg [7:0] neg_divisor; // Negated absolute value of divisor
reg [3:0] cnt; // Counter (widened to 4 bits)
reg start_cnt; // Start counter signal

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid <= 0;
        result <= 0;
    end else if (opn_valid &&!res_valid) begin
        if (divisor == 0) begin
            // Handle division by zero
            result <= {8'hFF, 8'h00}; // Example: set quotient to 0 and remainder to FF
            res_valid <= 1;
        end else if (sign) begin
            // Signed division
            sr <= {dividend[7]? {8{1'b1}} : {8{1'b0}}} + {dividend, 1'b0};
            neg_divisor <= ({divisor[7]? {8{1'b1}} : {8{1'b0}}} + (~divisor + 1)); // Correctly calculate negated absolute value
        end else begin
            // Unsigned division
            sr <= {dividend, 1'b0};
            neg_divisor <= (~divisor + 1); // Correctly calculate negated absolute value
        end
        cnt <= 1;
        start_cnt <= 1;
        res_valid <= 0;
    end else if (start_cnt) begin
        if (cnt == 8) begin
            // Division complete
            result <= {sr[15:8], sr[7:0]};
            res_valid <= 1;
            start_cnt <= 0;
        end else begin
            reg [16:0] temp;
            temp = {1'b0, sr} - {1'b0, neg_divisor};
            if (temp[16]) begin
                // No borrow
                sr <= {sr[14:0], 1'b0};
            end else begin
                // Borrow
                sr <= {1'b1, sr[14:0]};
            end
            cnt <= cnt + 1;
        end
    end else if (res_valid) begin
        // Reset result validity when result is consumed (e.g., when it's no longer needed)
        res_valid <= 0;
    end
end

endmodule