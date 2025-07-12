module radix2_div(
    input           clk,
    input           rst,
    input           sign,
    input   [7:0]   dividend,
    input   [7:0]   divisor,
    input           opn_valid,
    output          res_valid,
    output  [15:0]  result
);

// Internal signals
reg     [7:0]   abs_dividend;
reg     [7:0]   abs_divisor;
reg     [7:0]   neg_divisor;
reg     [8:0]   sr;
reg     [2:0]   cnt;
reg             start_cnt;
reg             carry_out;

// Initial values
always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
        start_cnt <= 1'b0;
        cnt <= 3'b000;
        sr <= 9'b0;
    end else if (opn_valid &&!res_valid) begin
        // Initialize internal signals
        if (sign) begin
            abs_dividend <= (dividend[7])? (~dividend + 1) : dividend;
            abs_divisor <= (divisor[7])? (~divisor + 1) : divisor;
        end else begin
            abs_dividend <= dividend;
            abs_divisor <= divisor;
        end
        neg_divisor <= (~abs_divisor + 1);
        sr <= {1'b0, abs_dividend};
        cnt <= 3'b001;
        start_cnt <= 1'b1;
    end
end

// Division process
always @(posedge clk) begin
    if (start_cnt) begin
        // Check if division is complete
        if (cnt == 3'b100) begin
            start_cnt <= 1'b0;
            cnt <= 3'b000;
            // Update result
            if (sign) begin
                if ((dividend[7])!= (divisor[7])) begin
                    result <= {sr[8:1], ~sr[0:0] + 1};
                end else begin
                    result <= {sr[8:1], sr[0:0]};
                end
            end else begin
                result <= {sr[8:1], sr[0:0]};
            end
            res_valid <= 1'b1;
        end else begin
            // Perform subtraction
            {carry_out, sr} <= sr - {1'b0, neg_divisor};
            // Update sr and cnt
            if (!carry_out) begin
                sr <= {1'b0, sr} | {8'b0, 1'b1};
            end else begin
                sr <= {1'b0, sr};
            end
            cnt <= cnt + 1'b1;
        end
    end
end

// Manage res_valid
always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
    end else if (res_valid &&!opn_valid) begin
        res_valid <= 1'b0;
    end
end

endmodule