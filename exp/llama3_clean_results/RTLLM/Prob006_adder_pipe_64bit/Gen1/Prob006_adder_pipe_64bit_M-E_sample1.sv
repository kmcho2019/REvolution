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
parameter STAGES = 4;

// Define the width of each pipeline stage
parameter WIDTH = 16;

// Define the total width of the input operands
parameter TOTAL_WIDTH = 64;

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
reg     [TOTAL_WIDTH-1:0] adda_reg;
reg     [TOTAL_WIDTH-1:0] addb_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= {TOTAL_WIDTH{1'b0}};
        addb_reg <= {TOTAL_WIDTH{1'b0}};
    end else if (i_en_reg) begin
        adda_reg <= adda;
        addb_reg <= addb;
    end else begin
        adda_reg <= adda_reg;
        addb_reg <= addb_reg;
    end
end

// Define the pipeline stages
reg     [WIDTH-1:0] stage1_sum;
reg     [WIDTH-1:0] stage2_sum;
reg     [WIDTH-1:0] stage3_sum;
reg     [WIDTH-1:0] stage4_sum;
reg             stage1_cout;
reg             stage2_cout;
reg             stage3_cout;
reg             stage4_cout;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        stage1_sum <= {WIDTH{1'b0}};
        stage2_sum <= {WIDTH{1'b0}};
        stage3_sum <= {WIDTH{1'b0}};
        stage4_sum <= {WIDTH{1'b0}};
        stage1_cout <= 1'b0;
        stage2_cout <= 1'b0;
        stage3_cout <= 1'b0;
        stage4_cout <= 1'b0;
    end else if (i_en_reg) begin
        // Stage 1
        {stage1_cout, stage1_sum} <= {1'b0, adda_reg[WIDTH-1:0]} + {1'b0, addb_reg[WIDTH-1:0]};
        
        // Stage 2
        {stage2_cout, stage2_sum} <= {stage1_cout, adda_reg[WIDTH*2-1:WIDTH]} + {stage1_cout, addb_reg[WIDTH*2-1:WIDTH]};
        
        // Stage 3
        {stage3_cout, stage3_sum} <= {stage2_cout, adda_reg[WIDTH*3-1:WIDTH*2]} + {stage2_cout, addb_reg[WIDTH*3-1:WIDTH*2]};
        
        // Stage 4
        {stage4_cout, stage4_sum} <= {stage3_cout, adda_reg[WIDTH*4-1:WIDTH*3]} + {stage3_cout, addb_reg[WIDTH*4-1:WIDTH*3]};
    end else begin
        stage1_sum <= stage1_sum;
        stage2_sum <= stage2_sum;
        stage3_sum <= stage3_sum;
        stage4_sum <= stage4_sum;
        stage1_cout <= stage1_cout;
        stage2_cout <= stage2_cout;
        stage3_cout <= stage3_cout;
        stage4_cout <= stage4_cout;
    end
end

// Output enable signal
reg     o_en_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        o_en_reg <= 1'b0;
    end else if (i_en_reg) begin
        o_en_reg <= 1'b0;
    end else if (stage4_cout == 1'b1 || stage4_sum!= {WIDTH{1'b0}}) begin
        o_en_reg <= 1'b1;
    end else begin
        o_en_reg <= o_en_reg;
    end
end

// Assign the output signals
assign result = {stage4_cout, stage4_sum, stage3_sum, stage2_sum, stage1_sum};
assign o_en = o_en_reg;

endmodule