module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

reg [63:0] stage1_adda;
reg [63:0] stage1_addb;
reg [64:0] stage2_sum;
reg i_en_sync;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_adda <= 64'd0;
        stage1_addb <= 64'd0;
        stage2_sum <= 65'd0;
        i_en_sync <= 1'b0;
        result <= 65'd0;
        o_en <= 1'b0;
    end else begin
        // Synchronize input enable signal
        i_en_sync <= i_en;
        
        // Store input operands in stage 1
        if (i_en_sync) begin
            stage1_adda <= adda;
            stage1_addb <= addb;
        end
        
        // Calculate sum in stage 2
        if (i_en_sync) begin
            stage2_sum <= stage1_adda + stage1_addb;
        end
        
        // Store output result
        if (i_en_sync) begin
            result <= stage2_sum;
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule