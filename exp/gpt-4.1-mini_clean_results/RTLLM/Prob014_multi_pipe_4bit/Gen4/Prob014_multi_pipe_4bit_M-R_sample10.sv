module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by 'size' zero bits at MSB side
    wire [2*size-1:0] ext_mul_a = { {size{1'b0}}, mul_a };

    // Generate partial products (size elements)
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Pipeline registers for stage 1: pairwise sum of partial products
    // Number of sums at stage 1 = ceil(size/2)
    localparam integer stage1_count = (size + 1) / 2;
    reg [2*size-1:0] stage1_regs [0:stage1_count-1];

    integer idx;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (idx = 0; idx < stage1_count; idx = idx + 1)
                stage1_regs[idx] <= {2*size{1'b0}};
        end else begin
            for (idx = 0; idx < stage1_count; idx = idx + 1) begin
                // Sum pairs of partial products or single if odd count
                if ((2*idx + 1) < size)
                    stage1_regs[idx] <= partial_products[2*idx] + partial_products[2*idx + 1];
                else
                    stage1_regs[idx] <= partial_products[2*idx];
            end
        end
    end

    // Pipeline registers for stage 2: sum the stage1_regs to get final output
    // Number of sums at stage 2 = ceil(stage1_count/2)
    localparam integer stage2_count = (stage1_count + 1) / 2;
    reg [2*size-1:0] stage2_regs [0:stage2_count-1];

    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < stage2_count; j = j + 1)
                stage2_regs[j] <= {2*size{1'b0}};
        end else begin
            for (j = 0; j < stage2_count; j = j + 1) begin
                if ((2*j + 1) < stage1_count)
                    stage2_regs[j] <= stage1_regs[2*j] + stage1_regs[2*j + 1];
                else
                    stage2_regs[j] <= stage1_regs[2*j];
            end
        end
    end

    // Final output register: if stage2_count > 1 sum again (rare for size=4)
    // For size=4:
    // stage1_count = 2 (4+1)/2=2
    // stage2_count = 1 (2+1)/2=1
    // So final mul_out = stage2_regs[0]

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {2*size{1'b0}};
        end else begin
            // For generality, if stage2_count == 1, output it
            // Else sum remaining stage2_regs elements (not needed for 4-bit multiplier)
            if (stage2_count == 1)
                mul_out <= stage2_regs[0];
            else begin
                integer k;
                reg [2*size-1:0] sum_tmp;
                sum_tmp = {2*size{1'b0}};
                for (k = 0; k < stage2_count; k = k + 1)
                    sum_tmp = sum_tmp + stage2_regs[k];
                mul_out <= sum_tmp;
            end
        end
    end

endmodule