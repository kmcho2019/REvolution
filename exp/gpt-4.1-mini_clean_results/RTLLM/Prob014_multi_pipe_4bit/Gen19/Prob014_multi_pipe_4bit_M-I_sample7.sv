module multi_pipe_4bit #(
    parameter size = 4
)(
    input                       clk,
    input                       rst_n,
    input      [size-1:0]       mul_a,
    input      [size-1:0]       mul_b,
    output reg [(2*size)-1:0]   mul_out
);

    // Extend multiplicand to 2*size bits by zero-padding MSBs
    wire [(2*size)-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // -------- Stage 1: Partial products generation and registering --------
    // Generate partial products: pp[i] = mul_b[i] ? (ext_mul_a << i) : 0
    // Register partial products to reduce combinational path
    
    wire [(2*size)-1:0] partial_products [size-1:0];
    reg  [(2*size)-1:0] stage1_regs [size-1:0];

    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : GEN_PARTIAL_PRODUCTS
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {(2*size){1'b0}};
        end
    endgenerate

    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j=0; j < size; j=j+1)
                stage1_regs[j] <= {(2*size){1'b0}};
        end else begin
            for (j=0; j < size; j=j+1)
                stage1_regs[j] <= partial_products[j];
        end
    end

    // -------- Stage 2: Pairwise addition of stage1 registers --------
    // For size=4, stage2 sums = 2 sums: (pp0+pp1), (pp2+pp3)
    // Register these sums to break combinational path

    localparam stage2_num = (size + 1) / 2; // 2 for size=4

    wire [(2*size)-1:0] stage2_sums [stage2_num-1:0];
    reg  [(2*size)-1:0] stage2_regs [stage2_num-1:0];

    generate
        for (i = 0; i < stage2_num; i = i + 1) begin : GEN_STAGE2_SUMS
            if (2*i + 1 < size) begin
                assign stage2_sums[i] = stage1_regs[2*i] + stage1_regs[2*i + 1];
            end else begin
                // Odd number of partial products, last sum equals last partial product directly
                assign stage2_sums[i] = stage1_regs[2*i];
            end
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j=0; j < stage2_num; j=j+1)
                stage2_regs[j] <= {(2*size){1'b0}};
        end else begin
            for (j=0; j < stage2_num; j=j+1)
                stage2_regs[j] <= stage2_sums[j];
        end
    end

    // -------- Final Stage: Combinational sum of stage2_regs + output register --------
    // Final addition done combinationally then registered
    
    wire [(2*size)-1:0] final_sum;
    generate
        if (stage2_num == 1) begin
            assign final_sum = stage2_regs[0];
        end else begin
            assign final_sum = stage2_regs[0] + stage2_regs[1];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {(2*size){1'b0}};
        else
            mul_out <= final_sum;
    end

endmodule