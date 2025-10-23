module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Input extension
wire [2*size-1:0] ext_a = { {size{1'b0}}, mul_a };

// Stage 1: Partial product generation (combinational)
wire [2*size-1:0] pp [0:size-1];
assign pp[0] = mul_b[0] ? ext_a : 0;
assign pp[1] = mul_b[1] ? (ext_a << 1) : 0;
assign pp[2] = mul_b[2] ? (ext_a << 2) : 0;
assign pp[3] = mul_b[3] ? (ext_a << 3) : 0;

// Stage 1 registers for partial products
reg [2*size-1:0] pp_reg [0:size-1];
integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < size; i = i + 1)
            pp_reg[i] <= 0;
    end else begin
        for (i = 0; i < size; i = i + 1)
            pp_reg[i] <= pp[i];
    end
end

// Stage 2: Intermediate sums
wire [2*size-1:0] sum01 = pp_reg[0] + pp_reg[1];
wire [2*size-1:0] sum23 = pp_reg[2] + pp_reg[3];

// Stage 2 register for intermediate sums
reg [2*size-1:0] sum01_reg, sum23_reg;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum01_reg <= 0;
        sum23_reg <= 0;
    end else begin
        sum01_reg <= sum01;
        sum23_reg <= sum23;
    end
end

// Final output stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 0;
    end else begin
        mul_out <= sum01_reg + sum23_reg;
    end
end

endmodule