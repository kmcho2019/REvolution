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
reg     [63:0] adda_reg;
reg     [63:0] addb_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= {64{1'b0}};
        addb_reg <= {64{1'b0}};
    end else if (i_en_reg) begin
        adda_reg <= adda;
        addb_reg <= addb;
    end else begin
        adda_reg <= adda_reg;
        addb_reg <= addb_reg;
    end
end

// Pipeline stages
reg [63:0] sum_reg;
reg        cout_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_reg <= {64{1'b0}};
        cout_reg <= 1'b0;
    end else if (i_en_reg) begin
        reg [7:0] segment_sum;
        reg        segment_cout;
        segment_sum = adda_reg[7:0] + addb_reg[7:0];
        segment_cout = (adda_reg[7:0] + addb_reg[7:0]) >= 256;
        sum_reg[7:0] <= segment_sum;
        cout_reg <= segment_cout;
        for (int i = 1; i < NUM_SEGMENTS; i++) begin
            segment_sum = adda_reg[(i+1)*SEGMENT_WIDTH-1:i*SEGMENT_WIDTH] + addb_reg[(i+1)*SEGMENT_WIDTH-1:i*SEGMENT_WIDTH] + cout_reg;
            segment_cout = (adda_reg[(i+1)*SEGMENT_WIDTH-1:i*SEGMENT_WIDTH] + addb_reg[(i+1)*SEGMENT_WIDTH-1:i*SEGMENT_WIDTH] + cout_reg) >= (1 << SEGMENT_WIDTH);
            sum_reg[(i+1)*SEGMENT_WIDTH-1:i*SEGMENT_WIDTH] <= segment_sum[SEGMENT_WIDTH-1:0];
            cout_reg <= segment_cout;
        end
    end else begin
        sum_reg <= sum_reg;
        cout_reg <= cout_reg;
    end
end

// Output enable signal
reg     o_en_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        o_en_reg <= 1'b0;
    end else if (i_en_reg) begin
        o_en_reg <= 1'b0;
    end else begin
        o_en_reg <= 1'b1;
    end
end

// Assign the output signals
assign result = {cout_reg, sum_reg};
assign o_en = o_en_reg;

endmodule