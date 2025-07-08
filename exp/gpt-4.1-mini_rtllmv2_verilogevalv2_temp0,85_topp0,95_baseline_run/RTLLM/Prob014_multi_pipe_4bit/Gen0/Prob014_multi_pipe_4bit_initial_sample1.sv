module multi_pipe_4bit #(
    parameter size = 4
)(
    input               clk,
    input               rst_n,
    input  [size-1:0]   mul_a,
    input  [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended inputs: prepend 'size' zeros to mul_a and mul_b
    wire [2*size-1:0] mul_a_ext = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] mul_b_ext = { {size{1'b0}}, mul_b };

    // Partial products generation
    // For each bit of mul_b (0 to size-1), partial product:
    // If mul_b[i] == 1, partial product = mul_a_ext << i, else 0
    wire [2*size-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for(i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (mul_a_ext << i) : {2*size{1'b0}};
        end
    endgenerate

    // First level registers for partial sums (pipeline stage 1)
    reg [2*size-1:0] stage1_reg0;
    reg [2*size-1:0] stage1_reg1;

    // Second level register for sum of first stage outputs (pipeline stage 2)
    reg [2*size-1:0] stage2_reg;

    // Summation logic:
    // Sum partial_products[0..1] -> stage1_reg0
    // Sum partial_products[2..3] -> stage1_reg1
    // Then sum stage1_reg0 + stage1_reg1 -> stage2_reg (final sum)
    wire [2*size-1:0] sum_stage1_0;
    wire [2*size-1:0] sum_stage1_1;
    wire [2*size-1:0] final_sum;

    assign sum_stage1_0 = partial_products[0] + partial_products[1];
    assign sum_stage1_1 = partial_products[2] + partial_products[3];
    assign final_sum = stage1_reg0 + stage1_reg1;

    // Sequential logic with asynchronous active-low reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_reg0 <= 0;
            stage1_reg1 <= 0;
            stage2_reg  <= 0;
            mul_out     <= 0;
        end else begin
            stage1_reg0 <= sum_stage1_0;
            stage1_reg1 <= sum_stage1_1;
            stage2_reg  <= final_sum;
            mul_out     <= stage2_reg;
        end
    end

endmodule