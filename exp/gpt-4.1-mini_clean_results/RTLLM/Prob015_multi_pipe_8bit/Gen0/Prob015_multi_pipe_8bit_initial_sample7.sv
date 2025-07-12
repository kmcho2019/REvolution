module multi_pipe_8bit (
    input         clk,
    input         rst_n,
    input         mul_en_in,
    input  [7:0]  mul_a,
    input  [7:0]  mul_b,
    output        mul_en_out,
    output [15:0] mul_out
);

// Stage 0 registers: latch inputs and enable
reg        mul_en_stage0;
reg [7:0]  mul_a_reg;
reg [7:0]  mul_b_reg;

// Stage 1 wires: partial products
wire [15:0] temp [7:0];

genvar i;
generate
    for(i=0; i<8; i=i+1) begin : gen_temp_partial_products
        assign temp[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

// Stage 1 registers: sum pairs of partial products
reg [15:0] sum_stage1_0;
reg [15:0] sum_stage1_1;
reg [15:0] sum_stage1_2;
reg [15:0] sum_stage1_3;
reg        mul_en_stage1;

// Stage 2 registers: sum stage1 results
reg [15:0] sum_stage2_0;
reg [15:0] sum_stage2_1;
reg        mul_en_stage2;

// Stage 3 register: final output sum
reg [15:0] mul_out_reg;
reg        mul_en_out_reg;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        mul_en_stage0 <= 1'b0;
        mul_a_reg     <= 8'd0;
        mul_b_reg     <= 8'd0;

        sum_stage1_0  <= 16'd0;
        sum_stage1_1  <= 16'd0;
        sum_stage1_2  <= 16'd0;
        sum_stage1_3  <= 16'd0;
        mul_en_stage1 <= 1'b0;

        sum_stage2_0  <= 16'd0;
        sum_stage2_1  <= 16'd0;
        mul_en_stage2 <= 1'b0;

        mul_out_reg   <= 16'd0;
        mul_en_out_reg <= 1'b0;
    end else begin
        // Stage 0: latch inputs and enable
        mul_en_stage0 <= mul_en_in;
        if(mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end

        // Stage 1: sum pairs of partial products and propagate enable
        sum_stage1_0 <= temp[0] + temp[1];
        sum_stage1_1 <= temp[2] + temp[3];
        sum_stage1_2 <= temp[4] + temp[5];
        sum_stage1_3 <= temp[6] + temp[7];
        mul_en_stage1 <= mul_en_stage0;

        // Stage 2: sum stage1 sums in pairs and propagate enable
        sum_stage2_0 <= sum_stage1_0 + sum_stage1_1;
        sum_stage2_1 <= sum_stage1_2 + sum_stage1_3;
        mul_en_stage2 <= mul_en_stage1;

        // Stage 3: final sum and propagate enable
        mul_out_reg <= sum_stage2_0 + sum_stage2_1;
        mul_en_out_reg <= mul_en_stage2;
    end
end

assign mul_en_out = mul_en_out_reg;
assign mul_out = mul_en_out_reg ? mul_out_reg : 16'd0;

endmodule