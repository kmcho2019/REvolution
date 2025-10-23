module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by padding MSBs with zeros
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Generate partial products combinationally and sum immediately
    // partial_products[i] = mul_b[i] ? (ext_mul_a << i) : 0
    // sum all partial products combinationally before stage 1 register
    wire [2*size-1:0] partial_products_sum;

    genvar i;
    wire [2*size-1:0] partial_products [size-1:0];

    generate
        for (i = 0; i < size; i = i + 1) begin : gen_pp
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Sum partial products combinationally
    wire [2*size-1:0] sum_pp_stage1;
    assign sum_pp_stage1 = partial_products[0]
                          + partial_products[1]
                          + partial_products[2]
                          + partial_products[3];
    
    // Stage 1 register: capture sum of partial products
    reg [2*size-1:0] stage1_reg;

    // Stage 2 register: output register capturing stage1_reg
    reg [2*size-1:0] stage2_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_reg <= {2*size{1'b0}};
            stage2_reg <= {2*size{1'b0}};
            mul_out    <= {2*size{1'b0}};
        end else begin
            stage1_reg <= sum_pp_stage1;
            stage2_reg <= stage1_reg;
            mul_out    <= stage2_reg;
        end
    end

endmodule