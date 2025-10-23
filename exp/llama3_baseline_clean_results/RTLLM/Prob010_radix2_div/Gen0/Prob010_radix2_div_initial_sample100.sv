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

// internal signals
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [15:0] sr;
reg [7:0] neg_divisor;
reg [2:0] cnt;
reg start_cnt;
reg [15:0] result_reg;

// Initialize registers
always @(posedge clk or posedge rst) begin
    if (rst) begin
        dividend_reg <= 8'd0;
        divisor_reg <= 8'd0;
        sr <= 16'd0;
        neg_divisor <= 8'd0;
        cnt <= 3'd0;
        start_cnt <= 1'd0;
        res_valid <= 1'd0;
        result_reg <= 16'd0;
    end
    else if (opn_valid &&!res_valid) begin
        // save inputs
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        // initialize shift register SR
        sr <= (sign)? ({8'd0, {7{dividend_reg[7]}}, dividend_reg[6:0]}) : ({8'd0, {7{1'b0}}, dividend_reg});
        // set NEG_DIVISOR
        neg_divisor <= (sign)? (~divisor_reg + 1'd1) : (~divisor_reg + 1'd1);
        // set counter and start_cnt
        cnt <= 3'd1;
        start_cnt <= 1'd1;
    end
end

// division process
always @(posedge clk) begin
    if (start_cnt) begin
        if (cnt == 8'd8) begin
            // division complete
            start_cnt <= 1'd0;
            cnt <= 3'd0;
            result_reg <= sr;
            res_valid <= 1'd1;
        end
        else begin
            // update shift register SR
            reg [8:0] sub;
            sub <= sr[15:8] - divisor_reg;
            sr <= (sub[8])? {1'b0, sr[14:0]} : {1'b1, sr[14:0]};
            cnt <= cnt + 1'd1;
        end
    end
end

// manage result validity
always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'd0;
    end
    else if (opn_valid &&!res_valid) begin
        res_valid <= 1'd0;
    end
    else if (res_valid &&!opn_valid) begin
        res_valid <= 1'd1;
    end
    else if (res_valid && opn_valid) begin
        res_valid <= 1'd0;
    end
end

assign result = result_reg;

endmodule