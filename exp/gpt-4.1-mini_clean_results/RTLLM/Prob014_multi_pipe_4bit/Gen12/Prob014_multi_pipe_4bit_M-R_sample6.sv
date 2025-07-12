module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by size zeros at MSB side
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Generate partial products combinationally
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 1: Registers to store each partial product
    reg [2*size-1:0] stage1_pp [0:size-1];

    // Registers to hold stage1 enable for sequential addition in stage 2
    reg [size-1:0] stage1_mul_b;

    // Pipeline registers: stage1 stores partial products and mul_b (for controlling addition)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_mul_b <= 0;
            for (integer idx = 0; idx < size; idx = idx + 1) begin
                stage1_pp[idx] <= 0;
            end
        end else begin
            stage1_mul_b <= mul_b;
            for (integer idx = 0; idx < size; idx = idx + 1) begin
                stage1_pp[idx] <= partial_products[idx];
            end
        end
    end

    // Stage 2: Sequential addition of partial products registered from stage1_pp
    // Accumulate all partial products in one clock cycle using a simple for loop
    reg [2*size-1:0] sum_stage2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage2 <= 0;
            mul_out <= 0;
        end else begin
            // Sum all partial products from stage1_pp registers combinationally
            // Since partial products already registered, sum now synchronously
            sum_stage2 <= 0;
            for (integer idx = 0; idx < size; idx = idx + 1) begin
                sum_stage2 <= sum_stage2 + stage1_pp[idx];
            end
            mul_out <= sum_stage2;
        end
    end

endmodule