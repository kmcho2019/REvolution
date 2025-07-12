module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline stage 1: Input registration and partial products
    reg [7:0] stage1_a, stage1_b;
    reg stage1_en;
    
    // Pipeline stage 2: Final result
    reg [15:0] stage2_result;
    reg stage2_en;
    
    // Generate all partial products and sum them in one step
    wire [15:0] pp_sum = 
        ({8'b0, stage1_b[0] ? stage1_a : 8'b0}) +
        ({7'b0, stage1_b[1] ? stage1_a : 8'b0, 1'b0}) +
        ({6'b0, stage1_b[2] ? stage1_a : 8'b0, 2'b0}) +
        ({5'b0, stage1_b[3] ? stage1_a : 8'b0, 3'b0}) +
        ({4'b0, stage1_b[4] ? stage1_a : 8'b0, 4'b0}) +
        ({3'b0, stage1_b[5] ? stage1_a : 8'b0, 5'b0}) +
        ({2'b0, stage1_b[6] ? stage1_a : 8'b0, 6'b0}) +
        ({1'b0, stage1_b[7] ? stage1_a : 8'b0, 7'b0});
    
    // Pipeline register updates
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear all pipeline registers
            stage1_a <= 8'b0;
            stage1_b <= 8'b0;
            stage1_en <= 1'b0;
            stage2_result <= 16'b0;
            stage2_en <= 1'b0;
        end else begin
            // Stage 1: Register inputs
            stage1_a <= mul_a;
            stage1_b <= mul_b;
            stage1_en <= mul_en_in;
            
            // Stage 2: Register final result
            stage2_result <= pp_sum;
            stage2_en <= stage1_en;
        end
    end
    
    // Output assignments
    assign mul_en_out = stage2_en;
    assign mul_out = stage2_en ? stage2_result : 16'b0;

endmodule