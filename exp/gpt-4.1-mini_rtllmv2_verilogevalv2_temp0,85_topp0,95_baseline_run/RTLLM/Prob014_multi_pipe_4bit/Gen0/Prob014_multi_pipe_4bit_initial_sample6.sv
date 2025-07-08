module multi_pipe_4bit #(
    parameter size = 4
)(
    input  wire                   clk,
    input  wire                   rst_n,
    input  wire [size-1:0]        mul_a,
    input  wire [size-1:0]        mul_b,
    output reg  [2*size-1:0]      mul_out
);

    // Extended multiplicand: size MSB zeros + mul_a
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Partial products for each bit of mul_b
    wire [2*size-1:0] partial_product [size-1:0];

    genvar i;
    generate
        for(i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_product[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Two pipeline registers to hold intermediate sums
    reg [2*size-1:0] stage1_reg;
    reg [2*size-1:0] stage2_reg;

    // Pipeline stage 1: sum partial products 0 and 1
    // Pipeline stage 2: sum partial products 2 and 3
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_reg <= 0;
            stage2_reg <= 0;
        end else begin
            stage1_reg <= partial_product[0] + partial_product[1];
            stage2_reg <= partial_product[2] + partial_product[3];
        end
    end

    // Final output register: sum of stage1_reg and stage2_reg
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= stage1_reg + stage2_reg;
        end
    end

endmodule