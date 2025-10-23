module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output reg o_en
);

// Define the number of stages
localparam NUM_STAGES = 4;

// Define the width of each stage
localparam STAGE_WIDTH = 16;

// Define the width of the result
localparam RESULT_WIDTH = 65;

// Define the width of the carry
localparam CARRY_WIDTH = 1;

// Define the registers for each stage
reg [STAGE_WIDTH-1:0] stage_sum [NUM_STAGES-1:0];
reg [CARRY_WIDTH-1:0] stage_carry [NUM_STAGES-1:0];

// Define the input and output registers
reg [63:0] adda_reg;
reg [63:0] addb_reg;

// Define the output register
reg [RESULT_WIDTH-1:0] result_reg;

// Define the enable register
reg i_en_reg;

// Define the output enable register
reg o_en_reg;

// Synchronize the input enable signal with the clock and reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i_en_reg <= 1'b0;
    end else begin
        i_en_reg <= i_en;
    end
end

// Stage 1: 16-bit adder
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage_sum[0] <= 16'd0;
        stage_carry[0] <= 1'd0;
    end else if (i_en_reg) begin
        {stage_carry[0], stage_sum[0]} <= adda[15:0] + addb[15:0];
    end
end

// Stage 2: 16-bit adder
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage_sum[1] <= 16'd0;
        stage_carry[1] <= 1'd0;
    end else if (i_en_reg) begin
        {stage_carry[1], stage_sum[1]} <= adda[31:16] + addb[31:16] + stage_carry[0];
    end
end

// Stage 3: 16-bit adder
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage_sum[2] <= 16'd0;
        stage_carry[2] <= 1'd0;
    end else if (i_en_reg) begin
        {stage_carry[2], stage_sum[2]} <= adda[47:32] + addb[47:32] + stage_carry[1];
    end
end

// Stage 4: 16-bit adder
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage_sum[3] <= 16'd0;
        stage_carry[3] <= 1'd0;
    end else if (i_en_reg) begin
        {stage_carry[3], stage_sum[3]} <= adda[63:48] + addb[63:48] + stage_carry[2];
    end
end

// Generate the output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result_reg <= 65'd0;
        o_en_reg <= 1'b0;
    end else if (i_en_reg) begin
        result_reg <= {stage_carry[3], stage_sum[3], stage_sum[2], stage_sum[1], stage_sum[0]};
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= 1'b0;
    end
end

// Assign the output
assign result = result_reg;
assign o_en = o_en_reg;

endmodule