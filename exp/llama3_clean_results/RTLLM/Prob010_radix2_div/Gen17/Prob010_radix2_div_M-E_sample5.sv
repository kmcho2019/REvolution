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

// Internal signals and registers
reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] neg_divisor;
reg [15:0] shift_reg;
reg [3:0] cnt;
reg start_cnt;
reg [7:0] sub_result;
reg carry_out;
reg pipeline_valid;
reg [15:0] pipeline_result;

// Combinational logic for subtraction and carry-out
assign sub_result = shift_reg[15:8] - divisor_reg;
assign carry_out = (shift_reg[15:8] < divisor_reg)? 1'b1 : 1'b0;

// Pipeline stage for initialization
always @(posedge clk) begin
    if (rst) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        neg_divisor <= 0;
        pipeline_valid <= 0;
    end else if (opn_valid && !res_valid) begin
        dividend_reg <= sign? {{7{dividend[7]}}, dividend[7:0]} : dividend;
        divisor_reg <= sign? {{7{divisor[7]}}, divisor[7:0]} : divisor;
        neg_divisor <= ~divisor_reg + 1;
        pipeline_valid <= 1;
    end
end

// Pipeline stage for division process
always @(posedge clk) begin
    if (rst || !pipeline_valid) begin
        shift_reg <= 0;
        cnt <= 0;
        start_cnt <= 0;
    end else if (pipeline_valid && cnt < 8) begin
        if (cnt == 0) begin
            shift_reg <= {1'b0, dividend_reg};
            start_cnt <= 1;
        end else begin
            if (carry_out) begin
                shift_reg <= {sub_result, 1'b1, shift_reg[7:1]};
            end else begin
                shift_reg <= {shift_reg[15:8], 1'b0, shift_reg[7:1]};
            end
            cnt <= cnt + 1;
        end
    end else if (pipeline_valid && cnt == 8) begin
        pipeline_result <= {shift_reg[15:8], shift_reg[7:0]};
        pipeline_valid <= 0;
    end
end

// Output stage
always @(posedge clk) begin
    if (rst) begin
        res_valid <= 0;
        result <= 0;
    end else if (!res_valid && pipeline_result != 0) begin
        res_valid <= 1;
        result <= pipeline_result;
    end else if (res_valid && !opn_valid) begin
        res_valid <= 0;
    end
end

endmodule