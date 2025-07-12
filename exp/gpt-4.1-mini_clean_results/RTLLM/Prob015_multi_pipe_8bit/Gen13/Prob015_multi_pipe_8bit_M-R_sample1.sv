module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]   mul_a,
    input       [7:0]   mul_b,
    output              mul_en_out,
    output      [15:0]  mul_out
);

//--------------------------------------------------------
// Pipeline registers for enable signal (8-bit shift register)
// MSB represents output enable
//--------------------------------------------------------
reg [7:0] mul_en_pipe;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_pipe <= 8'b0;
    end else begin
        mul_en_pipe <= {mul_en_pipe[6:0], mul_en_in};
    end
end

assign mul_en_out = mul_en_pipe[7];

//--------------------------------------------------------
// Input registers for mul_a and mul_b, only loaded when mul_en_in is asserted
//--------------------------------------------------------
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

//--------------------------------------------------------
// Partial product generation (combinational)
// Each partial product is mul_a_reg shifted by i bits if mul_b_reg[i] is 1
//--------------------------------------------------------
wire [15:0] partial_products [7:0];

genvar i;
generate
    for (i=0; i<8; i=i+1) begin : gen_partial_products
        assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

//--------------------------------------------------------
// Pipeline Stage 1: Add partial products in pairs (4 adders)
// This reduces sum from 8 to 4 partial sums
//--------------------------------------------------------
wire [15:0] sum_stage1 [3:0];

assign sum_stage1[0] = partial_products[0] + partial_products[1];
assign sum_stage1[1] = partial_products[2] + partial_products[3];
assign sum_stage1[2] = partial_products[4] + partial_products[5];
assign sum_stage1[3] = partial_products[6] + partial_products[7];

// Register sums for stage 2 inputs
reg [15:0] sum_stage1_reg [3:0];
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage1_reg[0] <= 16'd0;
        sum_stage1_reg[1] <= 16'd0;
        sum_stage1_reg[2] <= 16'd0;
        sum_stage1_reg[3] <= 16'd0;
    end else begin
        // Register sums only when mul_en_pipe[6] is set because sums are valid one cycle after inputs registered
        if(mul_en_pipe[6]) begin
            sum_stage1_reg[0] <= sum_stage1[0];
            sum_stage1_reg[1] <= sum_stage1[1];
            sum_stage1_reg[2] <= sum_stage1[2];
            sum_stage1_reg[3] <= sum_stage1[3];
        end else begin
            sum_stage1_reg[0] <= 16'd0;
            sum_stage1_reg[1] <= 16'd0;
            sum_stage1_reg[2] <= 16'd0;
            sum_stage1_reg[3] <= 16'd0;
        end
    end
end

//--------------------------------------------------------
// Pipeline Stage 2: Add pairs of sums from stage 1 (2 adders)
// This reduces sum from 4 to 2 partial sums
//--------------------------------------------------------
wire [15:0] sum_stage2 [1:0];
assign sum_stage2[0] = sum_stage1_reg[0] + sum_stage1_reg[1];
assign sum_stage2[1] = sum_stage1_reg[2] + sum_stage1_reg[3];

// Register sums for stage 3 inputs
reg [15:0] sum_stage2_reg [1:0];
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage2_reg[0] <= 16'd0;
        sum_stage2_reg[1] <= 16'd0;
    end else begin
        // Valid when mul_en_pipe[7] is set (next cycle after stage1 reg)
        if(mul_en_pipe[7]) begin
            sum_stage2_reg[0] <= sum_stage2[0];
            sum_stage2_reg[1] <= sum_stage2[1];
        end else begin
            sum_stage2_reg[0] <= 16'd0;
            sum_stage2_reg[1] <= 16'd0;
        end
    end
end

//--------------------------------------------------------
// Pipeline Stage 3: Final sum of two sums from stage 2 to produce product
//--------------------------------------------------------
reg [15:0] mul_out_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'd0;
    end else begin
        // Valid when mul_en_pipe[7] is set, sum_stage2_reg has valid sums
        if(mul_en_pipe[7]) begin
            mul_out_reg <= sum_stage2_reg[0] + sum_stage2_reg[1];
        end else begin
            mul_out_reg <= 16'd0;
        end
    end
end

//--------------------------------------------------------
// Output assignment
//--------------------------------------------------------
assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule