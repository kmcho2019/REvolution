module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Pipeline register for partial products
reg [2*size-1:0] pp0_reg, pp1_reg, pp2_reg, pp3_reg;

// Generate partial products
wire [2*size-1:0] pp0 = mul_b[0] ? {{size{1'b0}}, mul_a} : {2*size{1'b0}};
wire [2*size-1:0] pp1 = mul_b[1] ? {{size-1{1'b0}}, mul_a, 1'b0} : {2*size{1'b0}};
wire [2*size-1:0] pp2 = mul_b[2] ? {{size-2{1'b0}}, mul_a, 2'b0} : {2*size{1'b0}};
wire [2*size-1:0] pp3 = mul_b[3] ? {{size-3{1'b0}}, mul_a, 3'b0} : {2*size{1'b0}};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear pipeline registers
        pp0_reg <= {2*size{1'b0}};
        pp1_reg <= {2*size{1'b0}};
        pp2_reg <= {2*size{1'b0}};
        pp3_reg <= {2*size{1'b0}};
        mul_out <= {2*size{1'b0}};
    end else begin
        // First pipeline stage: register partial products
        pp0_reg <= pp0;
        pp1_reg <= pp1;
        pp2_reg <= pp2;
        pp3_reg <= pp3;
        
        // Second pipeline stage: compute and register final sum
        mul_out <= pp0_reg + pp1_reg + pp2_reg + pp3_reg;
    end
end

endmodule