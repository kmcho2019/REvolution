module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Pipeline registers
reg [2*size-1:0] stage1_reg;  // First pipeline stage
reg [2*size-1:0] stage2_reg;  // Second pipeline stage

// Partial products (gated by mul_b bits)
wire [2*size-1:0] pp0 = mul_b[0] ? {{size{1'b0}}, mul_a} : {2*size{1'b0}};
wire [2*size-1:0] pp1 = mul_b[1] ? {{size-1{1'b0}}, mul_a, 1'b0} : {2*size{1'b0}};
wire [2*size-1:0] pp2 = mul_b[2] ? {{size-2{1'b0}}, mul_a, 2'b0} : {2*size{1'b0}};
wire [2*size-1:0] pp3 = mul_b[3] ? {{size-3{1'b0}}, mul_a, 3'b0} : {2*size{1'b0}};

// Combinational sums
wire [2*size-1:0] sum01 = pp0 + pp1;
wire [2*size-1:0] sum23 = pp2 + pp3;
wire [2*size-1:0] final_sum = stage1_reg + stage2_reg;

// Pipeline stage 1: register first partial sum
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_reg <= {2*size{1'b0}};
    end else begin
        stage1_reg <= sum01;
    end
end

// Pipeline stage 2: register second partial sum
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_reg <= {2*size{1'b0}};
    end else begin
        stage2_reg <= sum23;
    end
end

// Final output stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= {2*size{1'b0}};
    end else begin
        mul_out <= final_sum;
    end
end

endmodule