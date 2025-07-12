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
    reg [15:0] stage1_sum;
    reg [15:0] stage2_sum;
    reg [15:0] stage3_sum;
    
    // Enable signal pipeline
    reg [3:0] en_pipe;

    // Partial products (combinational)
    wire [15:0] pp0 = {8'b0, stage0_b[0] ? stage0_a : 8'b0};
    wire [15:0] pp1 = {7'b0, stage0_b[1] ? stage0_a : 8'b0, 1'b0};
    wire [15:0] pp2 = {6'b0, stage0_b[2] ? stage0_a : 8'b0, 2'b0};
    wire [15:0] pp3 = {5'b0, stage0_b[3] ? stage0_a : 8'b0, 3'b0};
    wire [15:0] pp4 = {4'b0, stage0_b[4] ? stage0_a : 8'b0, 4'b0};
    wire [15:0] pp5 = {3'b0, stage0_b[5] ? stage0_a : 8'b0, 5'b0};
    wire [15:0] pp6 = {2'b0, stage0_b[6] ? stage0_a : 8'b0, 6'b0};
    wire [15:0] pp7 = {1'b0, stage0_b[7] ? stage0_a : 8'b0, 7'b0};

    // Pipeline stage 1 combinational logic
    wire [15:0] stage1_sum_next = pp0 + pp1 + pp2;
    
    // Pipeline stage 2 combinational logic
    wire [15:0] stage2_sum_next = stage1_sum + pp3 + pp4;
    
    // Pipeline stage 3 combinational logic
    wire [15:0] stage3_sum_next = stage2_sum + pp5 + pp6;
    
    // Final output combinational logic
    wire [15:0] mul_out_next = stage3_sum + pp7;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            stage0_a <= 8'b0;
            stage0_b <= 8'b0;
            en_pipe <= 4'b0;
            stage1_sum <= 16'b0;
            stage2_sum <= 16'b0;
            stage3_sum <= 16'b0;
            mul_out <= 16'b0;
        end
        else begin
            // Pipeline the enable signal
            en_pipe <= {en_pipe[2:0], mul_en_in};
            
            // Stage 0: Capture inputs
            if (mul_en_in) begin
                stage0_a <= mul_a;
                stage0_b <= mul_b;
            end
            
            // Stage 1: First level of addition
            stage1_sum <= stage1_sum_next;
            
            // Stage 2: Second level of addition
            stage2_sum <= stage2_sum_next;
            
            // Stage 3: Third level of addition
            stage3_sum <= stage3_sum_next;
            
            // Final output
            mul_out <= mul_out_next;
        end
    end
    
    // Output enable is the last stage of enable pipeline
    always @* begin
        mul_en_out = en_pipe[3];
    end

endmodule