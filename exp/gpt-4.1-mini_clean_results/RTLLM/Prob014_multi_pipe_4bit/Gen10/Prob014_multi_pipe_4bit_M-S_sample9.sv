module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by 'size' zeros at MSB
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    integer i;

    // --- Stage 1 registers ---
    reg [2*size-1:0] stage1_partial_products [size-1:0];
    reg [size-1:0]   stage1_mul_b;
    reg [2*size-1:0] stage1_mul_a;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_mul_a <= 0;
            stage1_mul_b <= 0;
            for (i = 0; i < size; i = i + 1)
                stage1_partial_products[i] <= 0;
        end else begin
            stage1_mul_a <= ext_mul_a;
            stage1_mul_b <= mul_b;
            // Generate partial products for each bit of multiplier
            for (i = 0; i < size; i = i + 1) begin
                stage1_partial_products[i] <= (mul_b[i]) ? (ext_mul_a << i) : {2*size{1'b0}};
            end
        end
    end

    // --- Stage 2 registers ---
    reg [2*size-1:0] stage2_sum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum <= 0;
            mul_out <= 0;
        end else begin
            // Sum partial products from stage 1
            stage2_sum <= stage1_partial_products[0]
                        + stage1_partial_products[1]
                        + stage1_partial_products[2]
                        + stage1_partial_products[3];
            mul_out <= stage2_sum;
        end
    end

endmodule