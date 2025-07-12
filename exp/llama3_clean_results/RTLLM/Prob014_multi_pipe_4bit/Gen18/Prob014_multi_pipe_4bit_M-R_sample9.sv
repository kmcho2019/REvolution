module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] stage1_out;
reg [2*size-1:0] stage2_out;

// Stage 1: Generate partial products
assign stage1_out = (mul_b[0] ? (mul_a << 0) : 0) +
                    (mul_b[1] ? (mul_a << 1) : 0) +
                    (mul_b[2] ? (mul_a << 2) : 0) +
                    (mul_b[3] ? (mul_a << 3) : 0);

// Stage 2: Sum the partial products (implemented in the next clock cycle)
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage2_out <= {2*size{1'b0}};
    end else begin
        stage2_out <= stage1_out;
    end
end

// Final stage: Output the result
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= {2*size{1'b0}};
    end else begin
        mul_out <= stage2_out;
    end
end

endmodule