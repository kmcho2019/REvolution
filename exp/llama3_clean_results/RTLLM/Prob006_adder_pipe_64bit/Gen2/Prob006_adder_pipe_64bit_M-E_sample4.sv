module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

// Define the segment size (e.g., 16 bits for simplicity)
localparam SEG_SIZE = 16;

// Calculate the number of segments
localparam NUM_SEG = 64 / SEG_SIZE;

// Internal signals for segment results and carries
reg [SEG_SIZE-1:0] seg_results [NUM_SEG-1:0];
reg [NUM_SEG-1:0] carries;

// Registered versions of inputs for pipeline
reg [63:0] adda_reg, addb_reg;
reg i_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        i_en_reg <= 1'b0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
        i_en_reg <= i_en;
    end
end

// Perform addition on each segment and handle carries
genvar i;
generate
    for (i = 0; i < NUM_SEG; i++) begin
        if (i == 0) begin
            // First segment addition without carry input
            always @(posedge clk) begin
                seg_results[i] <= adda_reg[SEG_SIZE-1:0] + addb_reg[SEG_SIZE-1:0];
                carries[i] <= (adda_reg[SEG_SIZE-1:0] + addb_reg[SEG_SIZE-1:0]) >= (1 << SEG_SIZE);
            end
        end else begin
            // Subsequent segments handle carry from previous segment
            always @(posedge clk) begin
                seg_results[i] <= adda_reg[(i+1)*SEG_SIZE-1:i*SEG_SIZE] + addb_reg[(i+1)*SEG_SIZE-1:i*SEG_SIZE] + carries[i-1];
                carries[i] <= (adda_reg[(i+1)*SEG_SIZE-1:i*SEG_SIZE] + addb_reg[(i+1)*SEG_SIZE-1:i*SEG_SIZE] + carries[i-1]) >= (1 << SEG_SIZE);
            end
        end
    end
endgenerate

// Combine segment results and final carry to form output
reg [64:0] sum_reg;
always @(posedge clk) begin
    sum_reg <= {carries[NUM_SEG-1], seg_results[NUM_SEG-1]};
    for (genvar j = NUM_SEG-2; j >= 0; j--) begin
        sum_reg <= {sum_reg, seg_results[j]};
    end
end

// Output enable signal
reg o_en_reg;
always @(posedge clk) begin
    o_en_reg <= i_en_reg;
end

assign result = sum_reg;
assign o_en = o_en_reg;

endmodule