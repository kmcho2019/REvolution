module radix2_div (
    input  wire        clk,
    input  wire        rst,
    input  wire        sign,
    input  wire [7:0]  dividend,
    input  wire [7:0]  divisor,
    input  wire        opn_valid,
    output wire        res_valid,
    output wire [15:0] result
);

reg [7:0]  sr;
reg [7:0]  neg_divisor;
reg [2:0]  cnt;
reg        start_cnt;
reg        res_valid_reg;
reg [15:0] result_reg;

wire [8:0]  sub_res;
wire        carry_out;

assign sub_res = {1'b0, sr} - {8'b0, neg_divisor};
assign carry_out = ~sub_res[8];

always @(posedge clk) begin
    if (rst) begin
        sr <= 0;
        neg_divisor <= 0;
        cnt <= 0;
        start_cnt <= 0;
        res_valid_reg <= 0;
        result_reg <= 0;
    end else if (opn_valid && ~res_valid_reg) begin
        // Save inputs and initialize shift register and NEG_DIVISOR
        sr <= (sign ? {1'b0, ~$signed(dividend)} + 1 : {1'b0, dividend}) << 1;
        neg_divisor <= ~$signed({1'b0, divisor}) + 1;
        cnt <= 1;
        start_cnt <= 1;
    end else if (start_cnt) begin
        // Division process
        if (cnt == 8) begin
            // Division complete, update result
            result_reg <= {sr[7:0], cnt - 1};
            res_valid_reg <= 1;
            cnt <= 0;
            start_cnt <= 0;
        end else begin
            // Update shift register based on subtraction result
            if (~carry_out) begin
                sr <= sub_res[7:0] << 1;
            end else begin
                sr <= ({1'b0, neg_divisor} + {1'b0, sr}) << 1;
            end
            cnt <= cnt + 1;
        end
    end
end

assign res_valid = res_valid_reg;
assign result = result_reg;

endmodule