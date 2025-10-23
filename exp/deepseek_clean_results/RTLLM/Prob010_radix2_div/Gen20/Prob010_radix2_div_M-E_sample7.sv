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

// Pipeline stage registers
reg [1:0] stage1_valid, stage2_valid;
reg [15:0] stage1_data, stage2_data;
reg [7:0] stage1_divisor, stage2_divisor;
reg stage1_sign, stage2_sign;
reg [3:0] stage1_cnt, stage2_cnt;

// Intermediate signals
wire [7:0] abs_dividend = (sign & dividend[7]) ? -dividend : dividend;
wire [7:0] abs_divisor = (sign & divisor[7]) ? -divisor : divisor;
wire result_sign = sign & (dividend[7] ^ divisor[7]);
wire div_by_zero = (divisor == 8'b0);

// Carry-save subtraction signals
wire [8:0] sub_value = {abs_divisor, 1'b0};
wire [8:0] remainder_ext = {stage1_data[15:8], 1'b0};
wire [8:0] sub_result = remainder_ext - sub_value;
wire sub_positive = ~sub_result[8];

// Pipeline stage 1: Input processing
always @(posedge clk or posedge rst) begin
    if (rst) begin
        stage1_valid <= 2'b00;
        stage1_data <= 16'b0;
        stage1_divisor <= 8'b0;
        stage1_sign <= 1'b0;
        stage1_cnt <= 4'b0;
    end else begin
        if (opn_valid && !div_by_zero) begin
            stage1_valid <= {stage1_valid[0], 1'b1};
            stage1_data <= {8'b0, abs_dividend};
            stage1_divisor <= abs_divisor;
            stage1_sign <= result_sign;
            stage1_cnt <= 4'd1;
        end else begin
            stage1_valid <= {stage1_valid[0], 1'b0};
        end
    end
end

// Pipeline stage 2: Division iteration
always @(posedge clk or posedge rst) begin
    if (rst) begin
        stage2_valid <= 2'b00;
        stage2_data <= 16'b0;
        stage2_divisor <= 8'b0;
        stage2_sign <= 1'b0;
        stage2_cnt <= 4'b0;
    end else begin
        stage2_valid <= stage1_valid;
        stage2_divisor <= stage1_divisor;
        stage2_sign <= stage1_sign;
        
        if (stage1_valid[0]) begin
            if (stage1_cnt == 4'd8) begin
                // Final iteration - adjust remainder
                if (stage1_data[15]) begin
                    stage2_data <= {stage1_data[15:8] + stage1_divisor, stage1_data[7:0]};
                end else begin
                    stage2_data <= stage1_data;
                end
                stage2_cnt <= 4'd0;
            end else begin
                // Regular iteration
                if (sub_positive) begin
                    stage2_data <= {sub_result[7:0], stage1_data[7:1], 1'b1};
                end else begin
                    stage2_data <= {stage1_data[15:8], stage1_data[7:1], 1'b0};
                end
                stage2_cnt <= stage1_cnt + 1;
            end
        end
    end
end

// Pipeline stage 3: Result formatting
always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
        result <= 16'b0;
    end else begin
        if (opn_valid && div_by_zero) begin
            // Immediate divide-by-zero result
            res_valid <= 1'b1;
            result <= {dividend, 8'hFF};
        end else if (stage2_valid[1]) begin
            // Normal result
            res_valid <= 1'b1;
            result <= {
                (sign & dividend[7]) ? -stage2_data[15:8] : stage2_data[15:8],
                stage2_sign ? -stage2_data[7:0] : stage2_data[7:0]
            };
        end else begin
            res_valid <= 1'b0;
        end
    end
end

endmodule