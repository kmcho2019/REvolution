module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Partial product generation (combinational)
wire [2*size-1:0] pp0 = mul_b[0] ? {size'b0, mul_a}        : {(2*size){1'b0}};
wire [2*size-1:0] pp1 = mul_b[1] ? {(size-1)'b0, mul_a, 1'b0} : {(2*size){1'b0}};
wire [2*size-1:0] pp2 = mul_b[2] ? {(size-2)'b0, mul_a, 2'b0} : {(2*size){1'b0}};
wire [2*size-1:0] pp3 = mul_b[3] ? {(size-3)'b0, mul_a, 3'b0} : {(2*size){1'b0}};

// Sum of partial products (combinational)
wire [2*size-1:0] sum_pp = pp0 + pp1 + pp2 + pp3;

// Pipeline registers
reg [2*size-1:0] stage1;
reg [2*size-1:0] stage2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1 <= {(2*size){1'b0}};
        stage2 <= {(2*size){1'b0}};
        mul_out <= {(2*size){1'b0}};
    end else begin
        stage1 <= sum_pp;    // Stage 1: Capture sum of partial products
        stage2 <= stage1;     // Stage 2: Pipeline register
        mul_out <= stage2;    // Output stage
    end
end

endmodule