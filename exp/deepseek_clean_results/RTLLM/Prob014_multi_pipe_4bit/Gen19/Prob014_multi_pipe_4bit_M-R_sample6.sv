module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Extended inputs
wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};
wire [2*size-1:0] ext_b = {{size{1'b0}}, mul_b};

// Partial products - calculated combinationally
wire [2*size-1:0] pp0 = mul_b[0] ? ext_a : 0;
wire [2*size-1:0] pp1 = mul_b[1] ? (ext_a << 1) : 0;
wire [2*size-1:0] pp2 = mul_b[2] ? (ext_a << 2) : 0;
wire [2*size-1:0] pp3 = mul_b[3] ? (ext_a << 3) : 0;

// Pipeline stage 1 registers
reg [2*size-1:0] pp0_reg, pp1_reg, pp2_reg, pp3_reg;
reg [2*size-1:0] sum01_reg, sum23_reg;

// First pipeline stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pp0_reg <= 0;
        pp1_reg <= 0;
        pp2_reg <= 0;
        pp3_reg <= 0;
        sum01_reg <= 0;
        sum23_reg <= 0;
    end else begin
        // Register partial products
        pp0_reg <= pp0;
        pp1_reg <= pp1;
        pp2_reg <= pp2;
        pp3_reg <= pp3;
        
        // First level additions
        sum01_reg <= pp0 + pp1;
        sum23_reg <= pp2 + pp3;
    end
end

// Second pipeline stage (final sum)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 0;
    end else begin
        mul_out <= sum01_reg + sum23_reg;
    end
end

endmodule