module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] stage1 [size-1:0];
reg [2*size-1:0] stage2;

integer i;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (i = 0; i < size; i++) begin
            stage1[i] <= 0;
        end
        stage2 <= 0;
        mul_out <= 0;
    end else begin
        for (i = 0; i < size; i++) begin
            if (mul_b[i]) begin
                stage1[i] <= {size{1'b0}} << (size - 1 - i) | (mul_a << i);
            end else begin
                stage1[i] <= 0;
            end
        end
        stage2 <= stage1[0];
        for (i = 1; i < size; i++) begin
            stage2 <= stage2 + stage1[i];
        end
        mul_out <= stage2;
    end
end

endmodule