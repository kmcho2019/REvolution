module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Pipeline stage 1 registers
reg [2*size-1:0] sum_reg, carry_reg;

// Generate partial products with clock gating
wire [2*size-1:0] pp0 = mul_b[0] ? {{size{1'b0}}, mul_a} : {2*size{1'b0}};
wire [2*size-1:0] pp1 = mul_b[1] ? {{size-1{1'b0}}, mul_a, 1'b0} : {2*size{1'b0}};
wire [2*size-1:0] pp2 = mul_b[2] ? {{size-2{1'b0}}, mul_a, 2'b0} : {2*size{1'b0}};
wire [2*size-1:0] pp3 = mul_b[3] ? {{size-3{1'b0}}, mul_a, 3'b0} : {2*size{1'b0}};

// First stage carry-save addition
wire [2*size-1:0] sum1 = pp0 ^ pp1;
wire [2*size-1:0] carry1 = (pp0 & pp1) << 1;

wire [2*size-1:0] sum2 = sum1 ^ pp2;
wire [2*size-1:0] carry2 = (sum1 & pp2) << 1;

wire [2*size-1:0] sum3 = sum2 ^ pp3;
wire [2*size-1:0] carry3 = (sum2 & pp3) << 1;

// Final addition (combinational)
wire [2*size-1:0] final_sum = sum_reg + carry_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear pipeline registers
        sum_reg <= {2*size{1'b0}};
        carry_reg <= {2*size{1'b0}};
        mul_out <= {2*size{1'b0}};
    end else begin
        // First pipeline stage: store intermediate sums
        sum_reg <= sum3;
        carry_reg <= carry1 | carry2 | carry3;
        
        // Second pipeline stage: compute final sum
        mul_out <= final_sum;
    end
end

endmodule