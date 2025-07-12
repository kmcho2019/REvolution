module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [size-1:0] mul_a_reg;
reg [size-1:0] mul_b_reg;
reg [2*size-1:0] stage1 [size-1:0];
reg [2*size-1:0] stage2;

// Stage 1: Multiply and shift
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < size; i++) begin
            stage1[i] <= {2*size{1'b0}};
        end
        mul_a_reg <= {size{1'b0}};
        mul_b_reg <= {size{1'b0}};
    end else begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        for (int i = 0; i < size; i++) begin
            if (mul_b_reg[i] == 1'b1) begin
                stage1[i] <= ({size{1'b0}, mul_a_reg} << i);
            end else begin
                stage1[i] <= {2*size{1'b0}};
            end
        end
    end
end

// Stage 2: Accumulate partial products
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage2 <= {2*size{1'b0}};
    end else begin
        stage2 <= {2*size{1'b0}};
        for (int i = 0; i < size; i++) begin
            stage2 <= stage2 + stage1[i];
        end
    end
end

// Output stage
always @(posedge clk) begin
    mul_out <= stage2;
end

endmodule