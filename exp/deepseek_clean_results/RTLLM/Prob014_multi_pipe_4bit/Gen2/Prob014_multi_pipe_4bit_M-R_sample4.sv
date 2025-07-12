module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Partial products generation using continuous assignment
wire [2*size-1:0] pp0 = mul_b[0] ? {size'b0, mul_a}       : {(2*size){1'b0}};
wire [2*size-1:0] pp1 = mul_b[1] ? {(size-1)'b0, mul_a, 1'b0} : {(2*size){1'b0}};
wire [2*size-1:0] pp2 = mul_b[2] ? {(size-2)'b0, mul_a, 2'b0} : {(2*size){1'b0}};
wire [2*size-1:0] pp3 = mul_b[3] ? {(size-3)'b0, mul_a, 3'b0} : {(2*size){1'b0}};

// Pipeline registers
reg [2*size-1:0] stage1_sum;
reg [2*size-1:0] stage2_sum;

// First pipeline stage: sum pp0 and pp1
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_sum <= {(2*size){1'b0}};
    end else begin
        stage1_sum <= pp0 + pp1;
    end
end

// Second pipeline stage: add pp2 and pp3
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_sum <= {(2*size){1'b0}};
        mul_out <= {(2*size){1'b0}};
    end else begin
        stage2_sum <= stage1_sum + pp2;
        mul_out <= stage2_sum + pp3;
    end
end

endmodule