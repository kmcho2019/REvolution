module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by zero-padding MSBs
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Partial products generation
    wire [2*size-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 1 combinational sums: sum pairs of partial products
    wire [2*size-1:0] sum_stage1_low  = partial_products[0] + partial_products[1];
    wire [2*size-1:0] sum_stage1_high = partial_products[2] + partial_products[3];

    // Stage 1 registers (pipeline stage 1)
    reg [2*size-1:0] stage1_sum_low_reg;
    reg [2*size-1:0] stage1_sum_high_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_sum_low_reg  <= {2*size{1'b0}};
            stage1_sum_high_reg <= {2*size{1'b0}};
        end else begin
            stage1_sum_low_reg  <= sum_stage1_low;
            stage1_sum_high_reg <= sum_stage1_high;
        end
    end

    // Stage 2 combinational sum (add outputs of stage 1 registers)
    wire [2*size-1:0] sum_stage2 = stage1_sum_low_reg + stage1_sum_high_reg;

    // Stage 2 register (pipeline stage 2)
    reg [2*size-1:0] stage2_sum_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum_reg <= {2*size{1'b0}};
            mul_out       <= {2*size{1'b0}};
        end else begin
            stage2_sum_reg <= sum_stage2;
            mul_out       <= stage2_sum_reg;
        end
    end

endmodule