module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Partial product wires
wire [2*size-1:0] pp0, pp1, pp2, pp3;

// Partial product generation using continuous assignment
assign pp0 = mul_b[0] ? {{size{1'b0}}, mul_a} : {(2*size){1'b0}};
assign pp1 = mul_b[1] ? {{size-1{1'b0}}, mul_a, 1'b0} : {(2*size){1'b0}};
assign pp2 = mul_b[2] ? {{size-2{1'b0}}, mul_a, 2'b0} : {(2*size){1'b0}};
assign pp3 = mul_b[3] ? {{size-3{1'b0}}, mul_a, 3'b0} : {(2*size){1'b0}};

// Pipeline registers
reg [2*size-1:0] pp0_reg, pp1_reg, pp2_reg, pp3_reg;
reg [2*size-1:0] sum_reg;

// First pipeline stage: register partial products
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pp0_reg <= {(2*size){1'b0}};
        pp1_reg <= {(2*size){1'b0}};
        pp2_reg <= {(2*size){1'b0}};
        pp3_reg <= {(2*size){1'b0}};
    end else begin
        pp0_reg <= pp0;
        pp1_reg <= pp1;
        pp2_reg <= pp2;
        pp3_reg <= pp3;
    end
end

// Second pipeline stage: sum and register final result
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_reg <= {(2*size){1'b0}};
        mul_out <= {(2*size){1'b0}};
    end else begin
        sum_reg <= pp0_reg + pp1_reg + pp2_reg + pp3_reg;
        mul_out <= sum_reg;
    end
end

endmodule