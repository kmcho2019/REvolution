module multi_pipe_8bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        mul_en_in,
    input  wire [7:0]  mul_a,
    input  wire [7:0]  mul_b,
    output wire        mul_en_out,
    output wire [15:0] mul_out
);

//------------------------------------------------------------------------------
// Stage 1: Input Registering and Partial Product Generation
//------------------------------------------------------------------------------
reg        mul_en_stage1;
reg [7:0]  mul_a_reg;
reg [7:0]  mul_b_reg;

// Partial products wires
// Each partial product corresponds to mul_a & replicated mul_b bit
wire [15:0] partial_products [7:0];

integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_stage1 <= 1'b0;
        mul_a_reg     <= 8'b0;
        mul_b_reg     <= 8'b0;
    end else begin
        mul_en_stage1 <= mul_en_in;
        if(mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end
end

// Generate partial products - shift mul_a_reg by bit index if mul_b_reg bit is set
// Each partial product is 16 bits wide for alignment
generate
    genvar idx;
    for (idx=0; idx<8; idx=idx+1) begin : gen_partial_products
        assign partial_products[idx] = mul_b_reg[idx] ? (mul_a_reg << idx) : 16'b0;
    end
endgenerate

//------------------------------------------------------------------------------
// Stage 2: Partial Sum Calculation - sum partial products in pairs to pipeline additions
//------------------------------------------------------------------------------
// Sum pairs of partial products to reduce addition latency and balance pipeline stages
// Stage 2 registers to store sums and enable signal
reg        mul_en_stage2;
reg [15:0] sum_0_1;
reg [15:0] sum_2_3;
reg [15:0] sum_4_5;
reg [15:0] sum_6_7;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        mul_en_stage2 <= 1'b0;
        sum_0_1       <= 16'b0;
        sum_2_3       <= 16'b0;
        sum_4_5       <= 16'b0;
        sum_6_7       <= 16'b0;
    end else begin
        mul_en_stage2 <= mul_en_stage1;
        if(mul_en_stage1) begin
            sum_0_1 <= partial_products[0] + partial_products[1];
            sum_2_3 <= partial_products[2] + partial_products[3];
            sum_4_5 <= partial_products[4] + partial_products[5];
            sum_6_7 <= partial_products[6] + partial_products[7];
        end else begin
            sum_0_1 <= 16'b0;
            sum_2_3 <= 16'b0;
            sum_4_5 <= 16'b0;
            sum_6_7 <= 16'b0;
        end
    end
end

//------------------------------------------------------------------------------
// Stage 3: Second Level Sum - add sums from stage 2 in pairs
//------------------------------------------------------------------------------
reg        mul_en_stage3;
reg [15:0] sum_0_3;
reg [15:0] sum_4_7;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        mul_en_stage3 <= 1'b0;
        sum_0_3       <= 16'b0;
        sum_4_7       <= 16'b0;
    end else begin
        mul_en_stage3 <= mul_en_stage2;
        if(mul_en_stage2) begin
            sum_0_3 <= sum_0_1 + sum_2_3;
            sum_4_7 <= sum_4_5 + sum_6_7;
        end else begin
            sum_0_3 <= 16'b0;
            sum_4_7 <= 16'b0;
        end
    end
end

//------------------------------------------------------------------------------
// Stage 4: Final Sum - add final two sums to get product
//------------------------------------------------------------------------------
reg        mul_en_stage4;
reg [15:0] mul_out_reg;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        mul_en_stage4 <= 1'b0;
        mul_out_reg   <= 16'b0;
    end else begin
        mul_en_stage4 <= mul_en_stage3;
        if(mul_en_stage3) begin
            mul_out_reg <= sum_0_3 + sum_4_7;
        end else begin
            mul_out_reg <= 16'b0;
        end
    end
end

//------------------------------------------------------------------------------
// Output assignments
//------------------------------------------------------------------------------
assign mul_en_out = mul_en_stage4;
assign mul_out    = mul_en_stage4 ? mul_out_reg : 16'b0;

endmodule