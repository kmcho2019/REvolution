module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by 'size' zeros at MSB side
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Generate partial products combinationally
    wire [2*size-1:0] partial_products [size-1:0];

    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // --- Stage 1 registers ---
    reg [2*size-1:0] stage1_partial_products [size-1:0];
    reg [size-1:0]   stage1_mul_b;
    reg [2*size-1:0] stage1_mul_a;

    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_mul_a <= 0;
            stage1_mul_b <= 0;
            for (j=0; j<size; j=j+1) begin
                stage1_partial_products[j] <= 0;
            end
        end else begin
            stage1_mul_a <= ext_mul_a;
            stage1_mul_b <= mul_b;
            for (j=0; j<size; j=j+1) begin
                stage1_partial_products[j] <= partial_products[j];
            end
        end
    end

    // --- Stage 2: combinational sum of partial products from stage 1 ---
    reg [2*size-1:0] stage2_sum;

    always @(*) begin
        stage2_sum = {2*size{1'b0}};
        for (j=0; j<size; j=j+1) begin
            stage2_sum = stage2_sum + stage1_partial_products[j];
        end
    end

    // --- Stage 2 register: output product ---
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= stage2_sum;
        end
    end

endmodule