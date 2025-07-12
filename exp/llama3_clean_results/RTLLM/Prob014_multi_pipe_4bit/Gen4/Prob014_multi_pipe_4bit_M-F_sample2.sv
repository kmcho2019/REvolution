module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] stage1;
reg [2*size-1:0] stage2;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1 <= {2*size{1'b0}};
        stage2 <= {2*size{1'b0}};
    end else begin
        // Stage 1: Process bits 0 and 1 of mul_b
        if (mul_b[0] == 1'b1) begin
            stage1 <= {size{1'b0}} + mul_a;
        end else begin
            stage1 <= {2*size{1'b0}};
        end

        if (mul_b[1] == 1'b1) begin
            stage1 <= stage1 + ({size{1'b0}} + (mul_a << 1));
        end

        // Stage 2: Process bits 2 and 3 of mul_b and accumulate with stage1
        if (mul_b[2] == 1'b1) begin
            stage2 <= stage1 + ({size{1'b0}} + (mul_a << 2));
        end else begin
            stage2 <= stage1;
        end

        if (mul_b[3] == 1'b1) begin
            stage2 <= stage2 + ({size{1'b0}} + (mul_a << 3));
        end
    end
end

always @(posedge clk) begin
    mul_out <= stage2;
end

endmodule