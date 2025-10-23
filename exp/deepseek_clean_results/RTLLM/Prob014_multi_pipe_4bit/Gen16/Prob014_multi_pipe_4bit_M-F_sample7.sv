module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Array for pipeline registers
reg [2*size-1:0] pp_reg [0:size-1];
wire [2*size-1:0] pp [0:size-1];

// Intermediate sums as registers
reg [2*size-1:0] sum01, sum23;

// Generate partial products conditionally
assign pp[0] = mul_b[0] ? {{size{1'b0}}, mul_a} : {2*size{1'b0}};
assign pp[1] = mul_b[1] ? {{size-1{1'b0}}, mul_a, 1'b0} : {2*size{1'b0}};
assign pp[2] = mul_b[2] ? {{size-2{1'b0}}, mul_a, 2'b0} : {2*size{1'b0}};
assign pp[3] = mul_b[3] ? {{size-3{1'b0}}, mul_a, 3'b0} : {2*size{1'b0}};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear pipeline registers
        for (integer i = 0; i < size; i = i + 1) begin
            pp_reg[i] <= {2*size{1'b0}};
        end
        sum01 <= {2*size{1'b0}};
        sum23 <= {2*size{1'b0}};
        mul_out <= {2*size{1'b0}};
    end else begin
        // First pipeline stage: register partial products
        for (integer i = 0; i < size; i = i + 1) begin
            pp_reg[i] <= pp[i];
        end
        
        // Second pipeline stage: compute sums using adder tree
        // Level 1 additions
        sum01 <= pp_reg[0] + pp_reg[1];
        sum23 <= pp_reg[2] + pp_reg[3];
        
        // Final output (Level 2 addition)
        mul_out <= sum01 + sum23;
    end
end

endmodule