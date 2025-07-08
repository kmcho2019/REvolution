module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [(2*size)-1:0] mul_out
);

    // Extended inputs by adding size zeros on MSB side
    wire [(2*size)-1:0] mul_a_ext = {{size{1'b0}}, mul_a};
    wire [(2*size)-1:0] partial_products [size-1:0];

    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (mul_a_ext << i) : {(2*size){1'b0}};
        end
    endgenerate

    // Two-level pipeline registers
    // Stage 1 registers for intermediate sums
    reg [(2*size)-1:0] stage1_sum0;
    reg [(2*size)-1:0] stage1_sum1;

    // Stage 2 register for final sum before output
    reg [(2*size)-1:0] stage2_sum;

    // First pipeline stage: sum partial_products[0] and partial_products[1]
    // and partial_products[2] and partial_products[3], store in stage1_sum0 and stage1_sum1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_sum0 <= {(2*size){1'b0}};
            stage1_sum1 <= {(2*size){1'b0}};
        end else begin
            stage1_sum0 <= partial_products[0] + partial_products[1];
            stage1_sum1 <= partial_products[2] + partial_products[3];
        end
    end

    // Second pipeline stage: sum stage1_sum0 and stage1_sum1 for final output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum <= {(2*size){1'b0}};
            mul_out <= {(2*size){1'b0}};
        end else begin
            stage2_sum <= stage1_sum0 + stage1_sum1;
            mul_out <= stage2_sum;
        end
    end

endmodule