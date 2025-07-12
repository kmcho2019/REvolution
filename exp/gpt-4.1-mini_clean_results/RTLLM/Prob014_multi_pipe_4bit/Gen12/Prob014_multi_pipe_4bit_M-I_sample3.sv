module multi_pipe_4bit #(
    parameter size = 4
)(
    input                         clk,
    input                         rst_n,
    input      [size-1:0]         mul_a,
    input      [size-1:0]         mul_b,
    output reg [2*size-1:0]       mul_out
);

    localparam extended_width = 2*size;

    // Extend multiplicand by adding 'size' zeros at MSB
    wire [extended_width-1:0] a_ext = {{size{1'b0}}, mul_a};

    // Partial product wires: size elements of extended_width bits
    wire [extended_width-1:0] partial_products [0:size-1];

    genvar i;
    generate
        for (i = 0; i < size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (a_ext << i) : {extended_width{1'b0}};
        end
    endgenerate

    // Stage 1: registers for partial products
    reg [extended_width-1:0] stage1_regs [0:size-1];

    integer idx;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (idx = 0; idx < size; idx = idx + 1)
                stage1_regs[idx] <= {extended_width{1'b0}};
        end else begin
            for (idx = 0; idx < size; idx = idx + 1)
                stage1_regs[idx] <= partial_products[idx];
        end
    end

    // Stage 2: sum partial products pairwise
    // For size=4, stage2_regs has size/2 = 2 registers
    localparam half_size = (size + 1) / 2; // Works also if size odd

    reg [extended_width-1:0] stage2_regs [0:half_size-1];

    // Pairwise sum wires
    wire [extended_width-1:0] stage2_sums [0:half_size-1];

    generate
        for (i = 0; i < half_size; i = i + 1) begin : gen_stage2_sums
            if ((2*i + 1) < size)
                assign stage2_sums[i] = stage1_regs[2*i] + stage1_regs[2*i + 1];
            else
                assign stage2_sums[i] = stage1_regs[2*i]; // Odd element left alone
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (idx = 0; idx < half_size; idx = idx +1)
                stage2_regs[idx] <= {extended_width{1'b0}};
        end else begin
            for (idx = 0; idx < half_size; idx = idx +1)
                stage2_regs[idx] <= stage2_sums[idx];
        end
    end

    // Stage 3: sum stage2 registers to get final product
    // For size=4 => half_size=2, so sum two registers
    wire [extended_width-1:0] final_sum = (half_size > 1) ? (stage2_regs[0] + stage2_regs[1]) : stage2_regs[0];

    reg [extended_width-1:0] stage3_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage3_reg <= {extended_width{1'b0}};
            mul_out   <= {extended_width{1'b0}};
        end else begin
            stage3_reg <= final_sum;
            mul_out   <= stage3_reg;
        end
    end

endmodule