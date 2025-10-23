module adder_pipe_64bit(
    input           clk,        // Clock input
    input           rst_n,      // Active low reset signal
    input           i_en,       // Enable signal for addition operation
    input   [63:0]   adda,       // 64-bit input operand A
    input   [63:0]   addb,       // 64-bit input operand B
    output  [64:0]   result,    // 65-bit output representing the sum of adda and addb
    output          o_en        // Output enable signal
);

// Define the number of segments
parameter NUM_SEGMENTS = 8;
parameter SEGMENT_WIDTH = 8;

// Synchronize the input enable signal
reg     i_en_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i_en_reg <= 1'b0;
    end else begin
        i_en_reg <= i_en;
    end
end

// Synchronize the input operands
reg     [63:0] adda_reg;
reg     [63:0] addb_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= {64{1'b0}};
        addb_reg <= {64{1'b0}};
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
    end
end

// Define the pipeline stages
reg [SEGMENT_WIDTH-1:0] segment_sum [0:NUM_SEGMENTS-1];
reg             segment_cout [0:NUM_SEGMENTS-1];

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < NUM_SEGMENTS; i++) begin
            segment_sum[i] <= {SEGMENT_WIDTH{1'b0}};
            segment_cout[i] <= 1'b0;
        end
    end else if (i_en) begin
        // Stage 0
        {segment_cout[0], segment_sum[0]} <= {1'b0, adda_reg[SEGMENT_WIDTH-1:0]} + {1'b0, addb_reg[SEGMENT_WIDTH-1:0]};
        
        // Remaining stages
        for (int i = 1; i < NUM_SEGMENTS; i++) begin
            {segment_cout[i], segment_sum[i]} <= {segment_cout[i-1], adda_reg[(i+1)*SEGMENT_WIDTH-1:i*SEGMENT_WIDTH]} + {segment_cout[i-1], addb_reg[(i+1)*SEGMENT_WIDTH-1:i*SEGMENT_WIDTH]};
        end
    end
end

// Output enable signal
reg     o_en_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        o_en_reg <= 1'b0;
    end else begin
        o_en_reg <= (i_en_reg && ~i_en); // o_en is high when i_en goes from high to low
    end
end

// Assign the output signals
assign result = {segment_cout[NUM_SEGMENTS-1], {segment_sum[7], segment_sum[6], segment_sum[5], segment_sum[4], segment_sum[3], segment_sum[2], segment_sum[1], segment_sum[0]}};
assign o_en = o_en_reg;

endmodule