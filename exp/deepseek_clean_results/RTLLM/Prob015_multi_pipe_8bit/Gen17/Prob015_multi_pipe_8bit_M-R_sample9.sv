module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline stage 1 registers (input sampling)
    reg [7:0] stage1_a, stage1_b;
    reg stage1_en;
    
    // Pipeline stage 2 registers (partial products)
    reg [15:0] stage2_pp [0:7];
    reg stage2_en;
    
    // Pipeline stage 3 registers (final result)
    reg [15:0] stage3_result;
    reg stage3_en;

    // Generate all partial products in parallel
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            always @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    stage2_pp[i] <= 16'b0;
                end else if (stage1_en) begin
                    stage2_pp[i] <= (stage1_b[i] ? {8'b0, stage1_a} << i : 16'b0);
                end
            end
        end
    endgenerate

    // Pipeline stage 1: Input registration
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_a <= 8'b0;
            stage1_b <= 8'b0;
            stage1_en <= 1'b0;
        end else begin
            stage1_a <= mul_a;
            stage1_b <= mul_b;
            stage1_en <= mul_en_in;
        end
    end

    // Pipeline stage 2: Enable propagation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_en <= 1'b0;
        end else begin
            stage2_en <= stage1_en;
        end
    end

    // Pipeline stage 3: Sum all partial products and output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage3_result <= 16'b0;
            stage3_en <= 1'b0;
        end else if (stage2_en) begin
            stage3_result <= stage2_pp[0] + stage2_pp[1] + stage2_pp[2] + stage2_pp[3] +
                             stage2_pp[4] + stage2_pp[5] + stage2_pp[6] + stage2_pp[7];
            stage3_en <= stage2_en;
        end
    end

    // Output assignments
    assign mul_en_out = stage3_en;
    assign mul_out = stage3_en ? stage3_result : 16'b0;

endmodule