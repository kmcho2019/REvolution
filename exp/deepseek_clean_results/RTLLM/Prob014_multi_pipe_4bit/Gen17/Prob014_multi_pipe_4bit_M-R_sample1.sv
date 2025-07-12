module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Pipeline stage registers
reg [2*size-1:0] stage1 [0:size-1];  // Partial product registers
reg [2*size-1:0] stage2_sum;         // Intermediate sum register

// Partial product generation wires
wire [2*size-1:0] pp [0:size-1];
assign pp[0] = mul_b[0] ? {{size{1'b0}}, mul_a} : {2*size{1'b0}};
assign pp[1] = mul_b[1] ? {{size-1{1'b0}}, mul_a, 1'b0} : {2*size{1'b0}};
assign pp[2] = mul_b[2] ? {{size-2{1'b0}}, mul_a, 2'b0} : {2*size{1'b0}};
assign pp[3] = mul_b[3] ? {{size-3{1'b0}}, mul_a, 3'b0} : {2*size{1'b0}};

// Continuous assignments for adder tree
wire [2*size-1:0] sum01 = stage1[0] + stage1[1];
wire [2*size-1:0] sum23 = stage1[2] + stage1[3];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear all pipeline registers
        for (integer i = 0; i < size; i = i + 1) begin
            stage1[i] <= {2*size{1'b0}};
        end
        stage2_sum <= {2*size{1'b0}};
        mul_out <= {2*size{1'b0}};
    end else begin
        // First pipeline stage: register partial products
        for (integer i = 0; i < size; i = i + 1) begin
            stage1[i] <= pp[i];
        end
        
        // Second pipeline stage: register intermediate sums
        stage2_sum <= sum01 + sum23;
        
        // Output stage
        mul_out <= stage2_sum;
    end
end

endmodule