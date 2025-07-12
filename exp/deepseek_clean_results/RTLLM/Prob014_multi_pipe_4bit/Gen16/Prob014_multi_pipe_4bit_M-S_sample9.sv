module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Single pipeline register
reg [2*size-1:0] sum01_reg;

// Generate all partial products (simpler implementation)
wire [2*size-1:0] pp0 = {{size{1'b0}}, mul_a};
wire [2*size-1:0] pp1 = {{size-1{1'b0}}, mul_a, 1'b0};
wire [2*size-1:0] pp2 = {{size-2{1'b0}}, mul_a, 2'b0};
wire [2*size-1:0] pp3 = {{size-3{1'b0}}, mul_a, 3'b0};

// Intermediate sums
wire [2*size-1:0] sum01 = pp0 + pp1;
wire [2*size-1:0] sum23 = pp2 + pp3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum01_reg <= {2*size{1'b0}};
        mul_out <= {2*size{1'b0}};
    end else begin
        // First pipeline stage: register first intermediate sum
        sum01_reg <= sum01;
        
        // Second pipeline stage: final sum
        mul_out <= sum01_reg + sum23;
    end
end

endmodule