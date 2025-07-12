module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output [2*size-1:0] mul_out
);

reg [2*size-1:0] reg1 [size-1:0];
reg [2*size-1:0] reg2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < size; i++) begin
            reg1[i] <= 0;
        end
        reg2 <= 0;
    end else begin
        reg1[0] <= (mul_b[0] ? {size{1'b0}}, mul_a : {2*size{1'b0}});
        for (int i = 1; i < size; i++) begin
            reg1[i] <= (mul_b[i] ? {{i{1'b0}}, mul_a, {size-i{1'b0}}} : {2*size{1'b0}});
        end
        reg2 <= reg1[0];
        for (int i = 1; i < size; i++) begin
            reg2 <= reg2 + reg1[i];
        end
    end
end

always @(posedge clk) begin
    mul_out <= reg2;
end

endmodule