module multi_pipe_4bit #(
    parameter size = 4
)(
    input                     clk,
    input                     rst_n,
    input      [size-1:0]     mul_a,
    input      [size-1:0]     mul_b,
    output reg [2*size-1:0]   mul_out
);

    // Extended inputs by adding 'size' zero bits at MSB side
    wire [2*size-1:0] a_ext = { {size{1'b0}}, mul_a };

    // Generate partial products based on bits of mul_b
    wire [2*size-1:0] partial_products [0:size-1];

    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (a_ext << i) : {2*size{1'b0}};
        end
    endgenerate

    // First pipeline stage registers to store partial products
    reg [2*size-1:0] stage1_regs [0:size-1];

    // Second pipeline stage registers to store intermediate sums
    // We will sum partial_products in pairs in the second stage to reduce additions in final stage
    reg [2*size-1:0] stage2_regs [0:(size+1)/2-1];

    integer j;

    // Stage 1: Register partial products
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            for (j = 0; j < size; j = j + 1)
                stage1_regs[j] <= {2*size{1'b0}};
        end else begin
            for (j = 0; j < size; j = j + 1)
                stage1_regs[j] <= partial_products[j];
        end
    end

    // Stage 2: Sum pairs of partial products from stage 1
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            for (j = 0; j < (size+1)/2; j = j + 1)
                stage2_regs[j] <= {2*size{1'b0}};
        end else begin
            for (j = 0; j < (size+1)/2; j = j + 1) begin
                if (2*j+1 < size)
                    stage2_regs[j] <= stage1_regs[2*j] + stage1_regs[2*j+1];
                else
                    stage2_regs[j] <= stage1_regs[2*j];
            end
        end
    end

    // Final output register: sum all values in stage2_regs
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            mul_out <= {2*size{1'b0}};
        end else begin
            // sum all stage2_regs elements
            reg [2*size-1:0] sum_tmp;
            sum_tmp = {2*size{1'b0}};
            for (j = 0; j < (size+1)/2; j = j + 1) begin
                sum_tmp = sum_tmp + stage2_regs[j];
            end
            mul_out <= sum_tmp;
        end
    end

endmodule