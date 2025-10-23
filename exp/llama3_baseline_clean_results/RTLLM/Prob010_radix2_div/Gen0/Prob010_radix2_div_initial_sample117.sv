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

reg [7:0] sr_reg;
reg [7:0] neg_divisor_reg;
reg [2:0] cnt_reg;
reg start_cnt_reg;
reg [15:0] result_reg;

wire [8:0] sub_result;
wire carry_out;

assign sub_result = {1'b0, sr_reg} - neg_divisor_reg;
assign carry_out = sub_result[8];

always @(*) begin
    if (rst) begin
        res_valid <= 1'b0;
        sr_reg <= 8'b0;
        neg_divisor_reg <= 8'b0;
        cnt_reg <= 3'b0;
        start_cnt_reg <= 1'b0;
        result_reg <= 16'b0;
    end else if (opn_valid && !res_valid) begin
        // Save inputs and initialize registers
        sr_reg <= {1'b0, (sign ? ~dividend + 1 : dividend)};
        neg_divisor_reg <= (sign ? ~divisor + 1 : divisor);
        cnt_reg <= 1;
        start_cnt_reg <= 1'b1;
        result_reg <= 16'b0;
    end else if (start_cnt_reg) begin
        if (cnt_reg == 8) begin
            // Division complete, update result and reset counters
            result_reg <= {sr_reg[7:0], sr_reg[7:0]};
            cnt_reg <= 3'b0;
            start_cnt_reg <= 1'b0;
        end else begin
            // Update shift register based on subtraction result
            if (carry_out) begin
                sr_reg <= sub_result[7:0];
            end else begin
                sr_reg <= {1'b0, sr_reg[7:0]} + 1'b1;
            end
            cnt_reg <= cnt_reg + 1;
        end
    end
end

always @(*) begin
    if (rst) begin
        res_valid <= 1'b0;
    end else if (start_cnt_reg && cnt_reg == 8) begin
        res_valid <= 1'b1;
    end else if (res_valid && !opn_valid) begin
        res_valid <= 1'b0;
    end
end

assign result = result_reg;

endmodule