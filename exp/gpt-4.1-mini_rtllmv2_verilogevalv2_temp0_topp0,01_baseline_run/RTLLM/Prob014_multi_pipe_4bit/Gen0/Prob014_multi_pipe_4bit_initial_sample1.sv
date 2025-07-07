module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend inputs by adding 'size' zeros at MSB side
    wire [2*size-1:0] ext_a = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] ext_b = { {size{1'b0}}, mul_b };

    // Generate partial products for each bit of mul_b
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = ext_b[i] ? (ext_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Two pipeline registers to store intermediate sums
    reg [2*size-1:0] reg_stage1; // sum of partial_products[0] and partial_products[1]
    reg [2*size-1:0] reg_stage2; // sum of partial_products[2] and partial_products[3]

    // First pipeline stage: sum partial products 0 and 1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            reg_stage1 <= {2*size{1'b0}};
        else
            reg_stage1 <= partial_products[0] + partial_products[1];
    end

    // Second pipeline stage: sum partial products 2 and 3
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            reg_stage2 <= {2*size{1'b0}};
        else
            reg_stage2 <= partial_products[2] + partial_products[3];
    end

    // Final product calculation: sum of reg_stage1 and reg_stage2
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {2*size{1'b0}};
        else
            mul_out <= reg_stage1 + reg_stage2;
    end

endmodule