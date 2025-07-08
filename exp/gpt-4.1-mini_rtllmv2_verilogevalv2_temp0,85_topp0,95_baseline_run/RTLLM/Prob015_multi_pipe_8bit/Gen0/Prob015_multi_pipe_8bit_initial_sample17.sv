module multi_pipe_8bit (
    input            clk,
    input            rst_n,
    input            mul_en_in,
    input      [7:0] mul_a,
    input      [7:0] mul_b,
    output           mul_en_out,
    output reg [15:0] mul_out
);

// Pipeline register depth: 8 stages (including input register stage and output stage)
// Registers for input enable signal pipeline (8 bits to track enable over pipeline)
reg [7:0] mul_en_out_reg;

// Input registers for mul_a and mul_b (latch inputs when mul_en_in is high)
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

// Partial products wires (8 partial products, each 16-bit aligned)
wire [15:0] partial_products [7:0];
genvar i;
generate
    for (i=0; i<8; i=i+1) begin : gen_partial_products
        assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'b0;
    end
endgenerate

// Pipeline registers for partial sums (7 stages)
// sum[0] through sum[6], each 16 bits
reg [15:0] sum [6:0];

// Pipeline stages for partial sums:
// Stage 0: sum[0] <= partial_products[0] + partial_products[1]
// Stage 1: sum[1] <= sum[0] + partial_products[2]
// Stage 2: sum[2] <= sum[1] + partial_products[3]
// Stage 3: sum[3] <= sum[2] + partial_products[4]
// Stage 4: sum[4] <= sum[3] + partial_products[5]
// Stage 5: sum[5] <= sum[4] + partial_products[6]
// Stage 6: sum[6] <= sum[5] + partial_products[7]

// Final output register for product
reg [15:0] mul_out_reg;

integer idx;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 8'b0;
        mul_a_reg      <= 8'b0;
        mul_b_reg      <= 8'b0;
        for (idx=0; idx<7; idx=idx+1)
            sum[idx] <= 16'b0;
        mul_out_reg <= 16'b0;
    end else begin
        // Pipeline input enable signal
        mul_en_out_reg <= {mul_en_out_reg[6:0], mul_en_in};

        // Register inputs when mul_en_in is high
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end

        // Pipeline partial sums
        // Stage 0
        sum[0] <= partial_products[0] + partial_products[1];
        // Stage 1
        sum[1] <= sum[0] + partial_products[2];
        // Stage 2
        sum[2] <= sum[1] + partial_products[3];
        // Stage 3
        sum[3] <= sum[2] + partial_products[4];
        // Stage 4
        sum[4] <= sum[3] + partial_products[5];
        // Stage 5
        sum[5] <= sum[4] + partial_products[6];
        // Stage 6
        sum[6] <= sum[5] + partial_products[7];

        // Final output register update
        mul_out_reg <= sum[6];
    end
end

// Output enable is the MSB of the mul_en_out_reg pipeline register
assign mul_en_out = mul_en_out_reg[7];

// Assign output product
always @(*) begin
    if (mul_en_out)
        mul_out = mul_out_reg;
    else
        mul_out = 16'b0;
end

endmodule