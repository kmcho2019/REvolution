module adder_pipe_64bit #(
    parameter CHUNK_SIZE = 32  // Configurable chunk size (32 or 16)
) (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

localparam NUM_CHUNKS = 64 / CHUNK_SIZE;

// Pipeline registers
reg [63:0] stage_a, stage_b;
reg [CHUNK_SIZE-1:0] sum_low_reg;
reg [CHUNK_SIZE-1:0] sum_high_reg;
reg carry_reg;
reg [1:0] en_pipe;

// Combinational sums
wire [CHUNK_SIZE:0] sum_low = {1'b0, stage_a[CHUNK_SIZE-1:0]} + {1'b0, stage_b[CHUNK_SIZE-1:0]};
wire [CHUNK_SIZE:0] sum_high = {1'b0, stage_a[63:CHUNK_SIZE]} + {1'b0, stage_b[63:CHUNK_SIZE]} + carry_reg;

// Input stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage_a <= 64'b0;
        stage_b <= 64'b0;
        en_pipe[0] <= 1'b0;
    end else begin
        stage_a <= adda;
        stage_b <= addb;
        en_pipe[0] <= i_en;
    end
end

// First pipeline stage (low chunk)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_low_reg <= {CHUNK_SIZE{1'b0}};
        carry_reg <= 1'b0;
        en_pipe[1] <= 1'b0;
    end else begin
        sum_low_reg <= sum_low[CHUNK_SIZE-1:0];
        carry_reg <= sum_low[CHUNK_SIZE];
        en_pipe[1] <= en_pipe[0];
    end
end

// Output stage (high chunk + final result)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum_high_reg <= {CHUNK_SIZE{1'b0}};
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        sum_high_reg <= sum_high[CHUNK_SIZE-1:0];
        result <= {sum_high[CHUNK_SIZE], sum_high_reg, sum_low_reg};
        o_en <= en_pipe[1];
    end
end

endmodule