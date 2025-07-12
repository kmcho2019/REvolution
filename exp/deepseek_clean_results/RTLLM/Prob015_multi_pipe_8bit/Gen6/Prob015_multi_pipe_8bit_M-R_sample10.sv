module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline Stage 1: Input Registration
    reg [7:0] stage1_a, stage1_b;
    reg stage1_en;
    
    // Pipeline Stage 2: Partial Product Generation
    reg [15:0] stage2_sum;
    reg stage2_en;
    
    // Pipeline Stage 3: Final Result
    reg [15:0] stage3_result;
    reg stage3_en;
    
    // Partial Products
    wire [15:0] pp [7:0];
    
    // Generate all partial products
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = stage1_b[i] ? ({8'b0, stage1_a} << i) : 16'b0;
        end
    endgenerate
    
    // Combinational sum of partial products
    wire [15:0] sum_pp;
    assign sum_pp = pp[0] + pp[1] + pp[2] + pp[3] + 
                   pp[4] + pp[5] + pp[6] + pp[7];
    
    // Pipeline Stage 1: Input Registration
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
    
    // Pipeline Stage 2: Partial Product Sum
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum <= 16'b0;
            stage2_en <= 1'b0;
        end else begin
            stage2_sum <= sum_pp;
            stage2_en <= stage1_en;
        end
    end
    
    // Pipeline Stage 3: Final Result
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage3_result <= 16'b0;
            stage3_en <= 1'b0;
        end else begin
            stage3_result <= stage2_sum;
            stage3_en <= stage2_en;
        end
    end
    
    // Output assignments
    assign mul_en_out = stage3_en;
    assign mul_out = stage3_en ? stage3_result : 16'b0;

endmodule