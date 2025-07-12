module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by size zeros at MSB side
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

    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            for (j = 0; j < size; j = j + 1)
                stage1_regs[j] <= {2*size{1'b0}};
        end else begin
            for (j = 0; j < size; j = j + 1)
                stage1_regs[j] <= partial_products[j];
        end
    end

    // Second pipeline stage register to store sum of partial products
    reg [2*size-1:0] stage2_reg;
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            stage2_reg <= {2*size{1'b0}};
        else begin
            // sum all partial products stored in stage1_regs
            reg [2*size-1:0] sum_tmp;
            sum_tmp = {2*size{1'b0}};
            for (j = 0; j < size; j = j + 1)
                sum_tmp = sum_tmp + stage1_regs[j];
            stage2_reg <= sum_tmp;
        end
    end

    // Output register stage: just transfer from stage2_reg
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            mul_out <= {2*size{1'b0}};
        else
            mul_out <= stage2_reg;
    end

endmodule