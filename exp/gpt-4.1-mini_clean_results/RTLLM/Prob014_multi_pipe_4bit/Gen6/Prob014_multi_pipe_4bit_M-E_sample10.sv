module multi_pipe_4bit #(parameter size = 4) (
    input                  clk,
    input                  rst_n,
    input      [size-1:0]  mul_a,
    input      [size-1:0]  mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended multiplicand with size zeros at MSB side (2*size bits)
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Stage 1 registers for inputs
    reg [size-1:0] stage1_mul_b;
    reg [2*size-1:0] stage1_ext_mul_a;

    // Partial products combinational wires generated from stage1 inputs
    wire [2*size-1:0] partial_products [0:size-1];

    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = stage1_mul_b[i] ? (stage1_ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 2 registers to hold partial products
    reg [2*size-1:0] stage2_partial_products [0:size-1];

    // Stage 3 register to hold the sum of partial products
    reg [2*size-1:0] stage3_sum;

    integer j;

    // Stage 1: Register inputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_mul_b <= 0;
            stage1_ext_mul_a <= 0;
        end else begin
            stage1_mul_b <= mul_b;
            stage1_ext_mul_a <= ext_mul_a;
        end
    end

    // Stage 2: Register partial products generated from stage 1 registered inputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j=0; j<size; j=j+1) begin
                stage2_partial_products[j] <= 0;
            end
        end else begin
            for (j=0; j<size; j=j+1) begin
                stage2_partial_products[j] <= partial_products[j];
            end
        end
    end

    // Stage 3: Sum the partial products from stage 2 registers and register output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage3_sum <= 0;
            mul_out <= 0;
        end else begin
            // Sum all partial products
            stage3_sum <= stage2_partial_products[0]
                        + stage2_partial_products[1]
                        + stage2_partial_products[2]
                        + stage2_partial_products[3];

            // Output registered sum
            mul_out <= stage3_sum;
        end
    end

endmodule