module multi_pipe_4bit #(
    parameter size = 4
)(
    input                     clk,
    input                     rst_n,
    input      [size-1:0]     mul_a,
    input      [size-1:0]     mul_b,
    output reg [2*size-1:0]   mul_out
);

    // Extended inputs: add 'size' zeros at MSB side
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a}; // size MSBs zero, then mul_a LSBs
    wire [2*size-1:0] partial_products [size-1:0];
    
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            // If mul_b[i] = 1, partial product is ext_mul_a shifted left by i, else zero
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // First level registers to hold partial sums (sum of partial products in pairs)
    reg [2*size-1:0] stage1_reg [size-1:0];
    integer j;
    
    // On each clk posedge or rst_n negedge, update stage1_reg
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j=0; j<size; j=j+1) begin
                stage1_reg[j] <= {2*size{1'b0}};
            end
        end else begin
            // Store partial products into stage1 registers
            for (j=0; j<size; j=j+1) begin
                stage1_reg[j] <= partial_products[j];
            end
        end
    end

    // Second level registers to hold intermediate sums
    reg [2*size-1:0] stage2_reg;
    
    // sum partial products stored in stage1_reg
    // Since size=4, sum all stage1_reg entries
    wire [2*size-1:0] sum_stage1;
    assign sum_stage1 = stage1_reg[0] + stage1_reg[1] + stage1_reg[2] + stage1_reg[3];

    // On each clk posedge or rst_n negedge, update stage2_reg
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_reg <= {2*size{1'b0}};
        end else begin
            stage2_reg <= sum_stage1;
        end
    end

    // On each clk posedge or rst_n negedge, update output mul_out
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {2*size{1'b0}};
        end else begin
            mul_out <= stage2_reg;
        end
    end

endmodule