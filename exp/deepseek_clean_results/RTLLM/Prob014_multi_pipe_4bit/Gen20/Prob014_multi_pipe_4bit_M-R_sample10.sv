module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Signal Declarations
// ------------------
// Extended inputs
wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};
wire [2*size-1:0] ext_b = {{size{1'b0}}, mul_b};

// Partial products (combinational)
wire [2*size-1:0] pp [0:size-1];
assign pp[0] = mul_b[0] ? ext_a : 'd0;
assign pp[1] = mul_b[1] ? (ext_a << 1) : 'd0;
assign pp[2] = mul_b[2] ? (ext_a << 2) : 'd0;
assign pp[3] = mul_b[3] ? (ext_a << 3) : 'd0;

// Pipeline Stage 1: Partial Product Registers
reg [2*size-1:0] pp_reg [0:size-1];
reg [2*size-1:0] sum01, sum23;

// Pipeline Stage 2: Sum Registers
reg [2*size-1:0] sum_stage2;

// Pipeline Stage 1: Sequential Logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (integer i = 0; i < size; i = i + 1)
            pp_reg[i] <= 'd0;
        sum01 <= 'd0;
        sum23 <= 'd0;
    end else begin
        // Register partial products
        for (integer i = 0; i < size; i = i + 1)
            pp_reg[i] <= pp[i];
            
        // First level additions
        sum01 <= pp[0] + pp[1];
        sum23 <= pp[2] + pp[3];
    end
end

// Pipeline Stage 2: Sequential Logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_stage2 <= 'd0;
    end else begin
        sum_stage2 <= sum01 + sum23;
    end
end

// Output Assignment
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 'd0;
    end else begin
        mul_out <= sum_stage2;
    end
end

endmodule