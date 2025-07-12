module multi_pipe_8bit (
    input               clk,
    input               rst_n,
    input               mul_en_in,
    input       [7:0]    mul_a,
    input       [7:0]    mul_b,
    output reg          mul_en_out,
    output reg  [15:0]   mul_out
);

    // Pipeline registers
    reg [7:0] stage0_a, stage0_b;
    reg [15:0] stage1_pp0, stage1_pp1, stage1_pp2;
    reg [15:0] stage2_pp3, stage2_pp4;
    reg [15:0] stage3_pp5, stage3_pp6;
    reg [15:0] stage4_pp7;
    
    // Enable signal pipeline
    reg [3:0] en_pipe;

    // Partial products (combinational)
    wire [15:0] pp0 = {8'b0, mul_b[0] ? mul_a : 8'b0};
    wire [15:0] pp1 = {7'b0, mul_b[1] ? mul_a : 8'b0, 1'b0};
    wire [15:0] pp2 = {6'b0, mul_b[2] ? mul_a : 8'b0, 2'b0};
    wire [15:0] pp3 = {5'b0, mul_b[3] ? mul_a : 8'b0, 3'b0};
    wire [15:0] pp4 = {4'b0, mul_b[4] ? mul_a : 8'b0, 4'b0};
    wire [15:0] pp5 = {3'b0, mul_b[5] ? mul_a : 8'b0, 5'b0};
    wire [15:0] pp6 = {2'b0, mul_b[6] ? mul_a : 8'b0, 6'b0};
    wire [15:0] pp7 = {1'b0, mul_b[7] ? mul_a : 8'b0, 7'b0};

    // Pipeline accumulation
    wire [15:0] sum_stage1 = stage1_pp0 + stage1_pp1 + stage1_pp2;
    wire [15:0] sum_stage2 = sum_stage1 + stage2_pp3 + stage2_pp4;
    wire [15:0] sum_stage3 = sum_stage2 + stage3_pp5 + stage3_pp6;
    wire [15:0] sum_final = sum_stage3 + stage4_pp7;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            stage0_a <= 8'b0;
            stage0_b <= 8'b0;
            en_pipe <= 4'b0;
            stage1_pp0 <= 16'b0;
            stage1_pp1 <= 16'b0;
            stage1_pp2 <= 16'b0;
            stage2_pp3 <= 16'b0;
            stage2_pp4 <= 16'b0;
            stage3_pp5 <= 16'b0;
            stage3_pp6 <= 16'b0;
            stage4_pp7 <= 16'b0;
            mul_out <= 16'b0;
        end
        else begin
            // Pipeline the enable signal
            en_pipe <= {en_pipe[2:0], mul_en_in};
            
            // Stage 0: Capture inputs when enabled
            if (mul_en_in) begin
                stage0_a <= mul_a;
                stage0_b <= mul_b;
            end
            
            // Stage 1: Register first set of partial products
            if (en_pipe[0]) begin
                stage1_pp0 <= pp0;
                stage1_pp1 <= pp1;
                stage1_pp2 <= pp2;
            end
            
            // Stage 2: Register next set of partial products
            if (en_pipe[1]) begin
                stage2_pp3 <= pp3;
                stage2_pp4 <= pp4;
            end
            
            // Stage 3: Register next set of partial products
            if (en_pipe[2]) begin
                stage3_pp5 <= pp5;
                stage3_pp6 <= pp6;
            end
            
            // Stage 4: Register final partial product
            if (en_pipe[3]) begin
                stage4_pp7 <= pp7;
                mul_out <= sum_final;
            end
        end
    end
    
    // Output enable is the last stage of enable pipeline
    always @* begin
        mul_en_out = en_pipe[3];
    end

endmodule