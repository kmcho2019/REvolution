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

reg [7:0] abs_dividend;
reg [7:0] abs_divisor;
reg [7:0] neg_divisor;
reg [15:0] sr; // shift register
reg [2:0] cnt; // counter
reg start_cnt; // start counter
reg [15:0] temp_result;

assign result = temp_result;

always @(posedge clk) begin
    if (rst) begin
        res_valid <= 1'b0;
        start_cnt <= 1'b0;
        cnt <= 3'b000;
        temp_result <= 16'b0;
    end else if (opn_valid && !res_valid) begin
        // save inputs
        abs_dividend <= (sign) ? {~dividend[7], dividend[7:0]} + 1 : dividend;
        abs_divisor <= (sign) ? {~divisor[7], divisor[7:0]} + 1 : divisor;
        neg_divisor <= ~abs_divisor + 1;
        sr <= {1'b0, abs_dividend}; // initialize shift register
        start_cnt <= 1'b1;
        cnt <= 1'b001;
        res_valid <= 1'b0;
    end else if (start_cnt) begin
        if (cnt == 8'b1000) begin
            // division complete
            temp_result <= {sr[15:8], sr[7:0]};
            start_cnt <= 1'b0;
            cnt <= 3'b000;
            res_valid <= 1'b1;
        end else begin
            // update shift register
            if (sr[15:8] >= {8'b0, neg_divisor}) begin
                sr <= {sr[14:0], 1'b1};
                sr <= sr - {8'b0, neg_divisor};
            end else begin
                sr <= {sr[14:0], 1'b0};
            end
            cnt <= cnt + 1'b1;
        end
    end else if (res_valid) begin
        // result consumed
        res_valid <= 1'b0;
    end
end

endmodule