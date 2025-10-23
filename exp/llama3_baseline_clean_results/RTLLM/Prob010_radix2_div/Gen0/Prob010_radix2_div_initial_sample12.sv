module radix2_div(
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output res_valid,
    output [15:0] result
);

// Internal signals
reg [7:0] abs_dividend;
reg [7:0] abs_divisor;
reg [7:0] neg_divisor;
reg [8:0] sr; // shift register
reg [2:0] cnt; // counter
reg start_cnt;
reg res_valid_reg;

// Initialize signals
always @(posedge clk) begin
    if (rst) begin
        cnt <= 0;
        start_cnt <= 0;
        res_valid_reg <= 0;
        sr <= 0;
    end else if (opn_valid && !res_valid_reg) begin
        // Save inputs and initialize signals
        abs_dividend <= (sign) ? {~dividend[7], dividend[7:0]} + 1 : dividend;
        abs_divisor <= (sign) ? {~divisor[7], divisor[7:0]} + 1 : divisor;
        neg_divisor <= ~abs_divisor + 1;
        sr <= {1'b0, abs_dividend};
        cnt <= 1;
        start_cnt <= 1;
        res_valid_reg <= 0;
    end else if (start_cnt) begin
        // Division process
        if (cnt == 8) begin
            // Division complete
            cnt <= 0;
            start_cnt <= 0;
            res_valid_reg <= 1;
            result <= {sr[8:1], sr[0:0]};
        end else begin
            // Update shift register
            reg [8:0] tmp;
            tmp <= sr + neg_divisor;
            if (tmp[8]) begin
                // No borrow, subtract and shift left
                sr <= {1'b0, sr[7:0]} + 1;
            end else begin
                // Borrow, do not subtract and shift left
                sr <= {1'b1, sr[7:0]};
            end
            cnt <= cnt + 1;
        end
    end else if (res_valid_reg) begin
        // Result is valid, reset when consumed
        res_valid_reg <= 0;
    end
end

assign res_valid = res_valid_reg;

endmodule