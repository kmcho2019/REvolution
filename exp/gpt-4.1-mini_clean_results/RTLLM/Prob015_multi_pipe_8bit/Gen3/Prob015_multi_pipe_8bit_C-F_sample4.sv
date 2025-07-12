module multi_pipe_8bit (
    input         clk,
    input         rst_n,
    input         mul_en_in,
    input  [7:0]  mul_a,
    input  [7:0]  mul_b,
    output        mul_en_out,
    output [15:0] mul_out
);

// Stage 0 registers: latch inputs and input enable
reg        mul_en_stage0;
reg [7:0]  mul_a_reg;
reg [7:0]  mul_b_reg;

// Stage 1 registers: partial products generation and register
reg [15:0] pp_reg [7:0];
reg        mul_en_stage1;

// Stage 2 registers: sum pairs of partial products (4 sums)
reg [15:0] sum_stage2 [3:0];
reg        mul_en_stage2;

// Stage 3 registers: sum pairs of stage2 sums (2 sums)
reg [15:0] sum_stage3 [1:0];
reg        mul_en_stage3;

// Stage 4 register: final sum (product) and output enable
reg [15:0] mul_out_reg;
reg        mul_en_stage4;

// Generate combinational partial products based on registered inputs (stage0 inputs latched)
wire [15:0] partial_products [7:0];
genvar i;
generate
    for (i=0; i<8; i=i+1) begin : gen_partial_products
        assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

integer idx;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_stage0 <= 1'b0;
        mul_a_reg     <= 8'd0;
        mul_b_reg     <= 8'd0;
    end else begin
        mul_en_stage0 <= mul_en_in;
        if(mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end
end

// Stage 1: register partial products and propagate enable
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_stage1 <= 1'b0;
        for(idx=0; idx<8; idx=idx+1) pp_reg[idx] <= 16'd0;
    end else begin
        mul_en_stage1 <= mul_en_stage0;
        if(mul_en_stage0) begin
            for(idx=0; idx<8; idx=idx+1) 
                pp_reg[idx] <= partial_products[idx];
        end else begin
            for(idx=0; idx<8; idx=idx+1)
                pp_reg[idx] <= 16'd0;
        end
    end
end

// Stage 2: sum pairs of partial products (0+1, 2+3, 4+5, 6+7) and register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_stage2 <= 1'b0;
        for(idx=0; idx<4; idx=idx+1) sum_stage2[idx] <= 16'd0;
    end else begin
        mul_en_stage2 <= mul_en_stage1;
        if(mul_en_stage1) begin
            sum_stage2[0] <= pp_reg[0] + pp_reg[1];
            sum_stage2[1] <= pp_reg[2] + pp_reg[3];
            sum_stage2[2] <= pp_reg[4] + pp_reg[5];
            sum_stage2[3] <= pp_reg[6] + pp_reg[7];
        end else begin
            for(idx=0; idx<4; idx=idx+1)
                sum_stage2[idx] <= 16'd0;
        end
    end
end

// Stage 3: sum pairs of stage 2 sums (0+1 and 2+3) and register
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_stage3 <= 1'b0;
        sum_stage3[0] <= 16'd0;
        sum_stage3[1] <= 16'd0;
    end else begin
        mul_en_stage3 <= mul_en_stage2;
        if(mul_en_stage2) begin
            sum_stage3[0] <= sum_stage2[0] + sum_stage2[1];
            sum_stage3[1] <= sum_stage2[2] + sum_stage2[3];
        end else begin
            sum_stage3[0] <= 16'd0;
            sum_stage3[1] <= 16'd0;
        end
    end
end

// Stage 4: final sum of last two sums and register output product and enable
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_stage4 <= 1'b0;
        mul_out_reg   <= 16'd0;
    end else begin
        mul_en_stage4 <= mul_en_stage3;
        if(mul_en_stage3) begin
            mul_out_reg <= sum_stage3[0] + sum_stage3[1];
        end else begin
            mul_out_reg <= 16'd0;
        end
    end
end

assign mul_en_out = mul_en_stage4;
assign mul_out = mul_en_stage4 ? mul_out_reg : 16'd0;

endmodule