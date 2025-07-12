module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by size zeros at MSB side
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Generate partial products combinationally (size partial products)
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 1 registers: register each partial product
    reg [2*size-1:0] stage1_pp [0:size-1];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_pp[0] <= 0;
            stage1_pp[1] <= 0;
            stage1_pp[2] <= 0;
            stage1_pp[3] <= 0;
        end else begin
            stage1_pp[0] <= partial_products[0];
            stage1_pp[1] <= partial_products[1];
            stage1_pp[2] <= partial_products[2];
            stage1_pp[3] <= partial_products[3];
        end
    end

    // Stage 2 registers: add pairs of stage1 partial products in pairs
    // Two adders: add (stage1_pp[0] + stage1_pp[1]) and (stage1_pp[2] + stage1_pp[3])
    reg [2*size-1:0] stage2_sum0, stage2_sum1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum0 <= 0;
            stage2_sum1 <= 0;
            mul_out <= 0;
        end else begin
            stage2_sum0 <= stage1_pp[0] + stage1_pp[1];
            stage2_sum1 <= stage1_pp[2] + stage1_pp[3];
            // mul_out will be updated at next clock with sum of stage2_sum0 and stage2_sum1
            mul_out <= stage2_sum0 + stage2_sum1;
        end
    end

endmodule