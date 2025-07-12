module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand with size zeros on MSB side to form 2*size bit
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Partial products generation
    wire [2*size-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_pp
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // First pipeline stage: sum pairs of partial products
    reg [2*size-1:0] stage1 [ (size/2)-1 : 0 ];
    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < size/2; j = j + 1)
                stage1[j] <= {2*size{1'b0}};
        end else begin
            for (j = 0; j < size/2; j = j + 1)
                stage1[j] <= partial_products[2*j] + partial_products[2*j + 1];
        end
    end

    // Second pipeline stage: sum stage1 outputs to produce final product
    reg [2*size-1:0] stage2;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2 <= {2*size{1'b0}};
            mul_out <= {2*size{1'b0}};
        end else begin
            stage2 <= stage1[0] + stage1[1];
            mul_out <= stage2;
        end
    end

endmodule