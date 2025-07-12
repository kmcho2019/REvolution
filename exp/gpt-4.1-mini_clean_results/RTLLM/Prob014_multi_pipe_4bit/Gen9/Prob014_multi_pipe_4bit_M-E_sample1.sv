module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by 'size' zero bits on MSB side
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    integer i;

    // --- Stage 1 registers ---
    // Register inputs
    reg [2*size-1:0] stage1_mul_a;
    reg [size-1:0]   stage1_mul_b;

    // Partial products at stage1 (packed array)
    reg [2*size-1:0] stage1_partial_products [size-1:0];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_mul_a <= 0;
            stage1_mul_b <= 0;
            for (i = 0; i < size; i = i + 1) begin
                stage1_partial_products[i] <= 0;
            end
        end else begin
            stage1_mul_a <= ext_mul_a;
            stage1_mul_b <= mul_b;
            for (i = 0; i < size; i = i + 1) begin
                // If multiplier bit i is set, partial product = ext_mul_a shifted left by i
                stage1_partial_products[i] <= (mul_b[i]) ? (ext_mul_a << i) : {2*size{1'b0}};
            end
        end
    end

    // --- Stage 2 registers ---
    // Sum partial products combinationally and register them
    reg [2*size-1:0] stage2_sum;

    always @(*) begin
        // combinational sum of all partial products from stage1 registers
        stage2_sum = {2*size{1'b0}};
        for (i = 0; i < size; i = i + 1) begin
            stage2_sum = stage2_sum + stage1_partial_products[i];
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= stage2_sum;
        end
    end

endmodule