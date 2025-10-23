module adder_pipe_64bit(
    input           clk,        // Clock input
    input           rst_n,      // Active low reset signal
    input           i_en,       // Enable signal for addition operation
    input   [63:0]   adda,       // 64-bit input operand A
    input   [63:0]   addb,       // 64-bit input operand B
    output  [64:0]   result,    // 65-bit output representing the sum of adda and addb
    output          o_en        // Output enable signal
);

// Define the number of pipeline stages
parameter DATA_WIDTH = 64;
parameter STG_WIDTH = 16;

// Define the number of stages
localparam NUM_STAGES = DATA_WIDTH / STG_WIDTH;

// Register to synchronize the input enable signal
reg     i_en_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i_en_reg <= 1'b0;
    end else begin
        i_en_reg <= i_en;
    end
end

// Register to synchronize the input operands
reg     [DATA_WIDTH-1:0] adda_reg;
reg     [DATA_WIDTH-1:0] addb_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= {DATA_WIDTH{1'b0}};
        addb_reg <= {DATA_WIDTH{1'b0}};
    end else if (i_en_reg) begin
        adda_reg <= adda;
        addb_reg <= addb;
    end else begin
        adda_reg <= adda_reg;
        addb_reg <= addb_reg;
    end
end

// Define the pipeline stages
reg     [STG_WIDTH-1:0] stage_sum [0:NUM_STAGES-1];
reg             stage_cout [0:NUM_STAGES-1];

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < NUM_STAGES; i++) begin
            stage_sum[i] <= {STG_WIDTH{1'b0}};
            stage_cout[i] <= 1'b0;
        end
    end else if (i_en_reg) begin
        // Stage 1
        {stage_cout[0], stage_sum[0]} <= {1'b0, adda_reg[15:0]} + {1'b0, addb_reg[15:0]};
        
        // Remaining stages
        for (int i = 1; i < NUM_STAGES; i++) begin
            {stage_cout[i], stage_sum[i]} <= {stage_cout[i-1], adda_reg[(i*16)+15:(i*16)]} + {stage_cout[i-1], addb_reg[(i*16)+15:(i*16)]};
        end
    end else begin
        for (int i = 0; i < NUM_STAGES; i++) begin
            stage_sum[i] <= stage_sum[i];
            stage_cout[i] <= stage_cout[i];
        end
    end
end

// Output enable signal
reg     o_en_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        o_en_reg <= 1'b0;
    end else if (i_en_reg) begin
        o_en_reg <= 1'b0;
    end else if (~i_en_reg && stage_cout[NUM_STAGES-1] == 1'b1) begin
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= o_en_reg;
    end
end

// Assign the output signals
reg [64:0] temp_result;
always @(posedge clk) begin
    temp_result <= {stage_cout[NUM_STAGES-1], stage_sum[3], stage_sum[2], stage_sum[1], stage_sum[0]};
end
assign result = temp_result;
assign o_en = o_en_reg;

endmodule