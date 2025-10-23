module radix2_div (
    input wire clk,
    input wire rst,
    input wire sign,
    input wire [7:0] dividend,
    input wire [7:0] divisor,
    input wire opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

// Pipeline registers
reg [3:0] pipeline_valid;
reg [7:0] stage1_dividend, stage1_divisor;
reg stage1_sign;
reg [8:0] stage2_remainder;
reg [7:0] stage2_divisor, stage2_neg_divisor;
reg stage2_sign, stage2_dividend_sign, stage2_divisor_sign;
reg [7:0] stage3_quotient;
reg [8:0] stage3_remainder;
reg stage3_sign, stage3_dividend_sign, stage3_divisor_sign;
reg [7:0] stage4_quotient, stage4_remainder;
reg stage4_sign_correction;

// Internal signals
wire [7:0] abs_dividend, abs_divisor;
wire dividend_sign, divisor_sign;
wire zero_divisor;
wire [8:0] partial_remainder [0:7];
wire [7:0] partial_quotient [0:7];
wire [8:0] final_remainder;

// Input stage
always @(posedge clk or posedge rst) begin
    if (rst) begin
        pipeline_valid <= 4'b0;
        stage1_dividend <= 8'b0;
        stage1_divisor <= 8'b0;
        stage1_sign <= 1'b0;
    end else begin
        // Stage 1: Input capture
        if (opn_valid) begin
            stage1_dividend <= dividend;
            stage1_divisor <= divisor;
            stage1_sign <= sign;
            pipeline_valid[0] <= 1'b1;
        end else begin
            pipeline_valid[0] <= 1'b0;
        end
        
        // Pipeline the valid signal
        pipeline_valid[3:1] <= pipeline_valid[2:0];
    end
end

// Absolute value and sign calculation
assign dividend_sign = stage1_sign & stage1_dividend[7];
assign divisor_sign = stage1_sign & stage1_divisor[7];
assign abs_dividend = dividend_sign ? -stage1_dividend : stage1_dividend;
assign abs_divisor = divisor_sign ? -stage1_divisor : stage1_divisor;
assign zero_divisor = (abs_divisor == 0);

// Setup stage
always @(posedge clk) begin
    if (pipeline_valid[0]) begin
        stage2_remainder <= {1'b0, abs_dividend};
        stage2_divisor <= abs_divisor;
        stage2_neg_divisor <= -abs_divisor;
        stage2_sign <= stage1_sign;
        stage2_dividend_sign <= dividend_sign;
        stage2_divisor_sign <= divisor_sign;
    end
end

// Division stage - unrolled for 8 bits
generate
    genvar i;
    for (i=0; i<8; i=i+1) begin : div_stages
        if (i == 0) begin
            assign partial_remainder[i] = {stage2_remainder[7:0], 1'b0} + 
                                         (stage2_remainder[8] ? stage2_divisor : stage2_neg_divisor);
        end else begin
            assign partial_remainder[i] = {partial_remainder[i-1][7:0], 1'b0} + 
                                         (partial_remainder[i-1][8] ? stage2_divisor : stage2_neg_divisor);
        end
        assign partial_quotient[i] = {partial_quotient[i-1][6:0], ~partial_remainder[i][8]};
    end
endgenerate

always @(posedge clk) begin
    if (pipeline_valid[1]) begin
        stage3_quotient <= zero_divisor ? 8'hFF : partial_quotient[7];
        stage3_remainder <= zero_divisor ? 9'h1FF : partial_remainder[7];
        stage3_sign <= stage2_sign;
        stage3_dividend_sign <= stage2_dividend_sign;
        stage3_divisor_sign <= stage2_divisor_sign;
    end
end

// Remainder correction and sign application
assign final_remainder = (stage3_remainder[8] ? 
                         stage3_remainder + {1'b0, stage2_divisor} : 
                         stage3_remainder);

always @(posedge clk) begin
    if (pipeline_valid[2]) begin
        stage4_quotient <= (stage3_dividend_sign ^ stage3_divisor_sign) ? 
                          -stage3_quotient : stage3_quotient;
        stage4_remainder <= stage3_dividend_sign ? 
                          -final_remainder[7:0] : final_remainder[7:0];
        stage4_sign_correction <= stage3_sign;
    end
end

// Output stage
always @(posedge clk or posedge rst) begin
    if (rst) begin
        res_valid <= 1'b0;
        result <= 16'b0;
    end else begin
        res_valid <= pipeline_valid[3];
        if (pipeline_valid[3]) begin
            result <= {stage4_remainder, stage4_quotient};
        end
    end
end

endmodule