module multi_pipe_4bit #(parameter size = 4)(
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by adding 'size' zeros at MSB side
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Stage 1: Register extended multiplicand and multiplier inputs
    reg [2*size-1:0] stage1_mul_a;
    reg [size-1:0]   stage1_mul_b;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_mul_a <= {2*size{1'b0}};
            stage1_mul_b <= {size{1'b0}};
        end else begin
            stage1_mul_a <= ext_mul_a;
            stage1_mul_b <= mul_b;
        end
    end

    // Stage 2: Generate and register partial products for each bit of the multiplier
    wire [2*size-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for (i = 0; i < size; i = i +1) begin : GEN_PARTIALS
            assign partial_products[i] = (stage1_mul_b[i]) ? (stage1_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Registers to store partial products (pipeline register stage 2)
    reg [2*size-1:0] stage2_partial_products [size-1:0];

    integer idx;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (idx = 0; idx < size; idx = idx +1) begin
                stage2_partial_products[idx] <= {2*size{1'b0}};
            end
        end else begin
            for (idx = 0; idx < size; idx = idx +1) begin
                stage2_partial_products[idx] <= partial_products[idx];
            end
        end
    end

    // Stage 3: Sum partial products in pairs combinationally, then register sums
    // sum pairs: [0]+[1], [2]+[3]
    wire [2*size-1:0] sum_pair0 = stage2_partial_products[0] + stage2_partial_products[1];
    wire [2*size-1:0] sum_pair1 = stage2_partial_products[2] + stage2_partial_products[3];

    reg [2*size-1:0] stage3_sum_pair0, stage3_sum_pair1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage3_sum_pair0 <= {2*size{1'b0}};
            stage3_sum_pair1 <= {2*size{1'b0}};
        end else begin
            stage3_sum_pair0 <= sum_pair0;
            stage3_sum_pair1 <= sum_pair1;
        end
    end

    // Stage 4: Final sum of sums from Stage 3, then register output
    wire [2*size-1:0] final_sum = stage3_sum_pair0 + stage3_sum_pair1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {2*size{1'b0}};
        end else begin
            mul_out <= final_sum;
        end
    end

endmodule