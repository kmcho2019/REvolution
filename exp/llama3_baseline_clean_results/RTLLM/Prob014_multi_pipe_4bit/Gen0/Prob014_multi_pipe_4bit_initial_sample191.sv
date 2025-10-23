module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output [7:0] mul_out
);

parameter size = 4;

reg [7:0] stage1 [0:size-1];
reg [7:0] stage2 [0:size-1];
reg [7:0] mul_out_reg;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the registers
        for (i = 0; i < size; i++) begin
            stage1[i] <= 8'd0;
            stage2[i] <= 8'd0;
        end
        mul_out_reg <= 8'd0;
    end else begin
        // Generate partial products and store in stage1
        for (i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                stage1[i] <= {4'd0, mul_a} << i;
            end else begin
                stage1[i] <= 8'd0;
            end
        end
        
        // Add partial products and store in stage2
        for (i = 0; i < size; i++) begin
            if (i == 0) begin
                stage2[i] <= stage1[i];
            end else begin
                stage2[i] <= stage2[i-1] + stage1[i];
            end
        end
        
        // Calculate final product
        mul_out_reg <= stage2[size-1];
    end
end

assign mul_out = mul_out_reg;

endmodule