module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Segment parameters
localparam SEG_WIDTH = 8;
localparam NUM_SEG = 8;
localparam PIPELINE_STAGES = NUM_SEG + 1;

// Pipeline registers
reg [63:0] a_pipe [0:NUM_SEG-1];
reg [63:0] b_pipe [0:NUM_SEG-1];
reg [NUM_SEG:0] carry_pipe;
reg [PIPELINE_STAGES-1:0] en_shift_reg = 0;

// Segment outputs
wire [SEG_WIDTH:0] seg_sum [0:NUM_SEG-1];  // sum + carry out
wire [NUM_SEG-1:0] seg_propagate;
wire [NUM_SEG-1:0] seg_generate;

// Carry skip logic
wire [NUM_SEG:0] carry_chain;
assign carry_chain[0] = carry_pipe[0];

// Generate all segments
genvar i;
generate
    for (i = 0; i < NUM_SEG; i = i + 1) begin : SEGMENTS
        // Current segment inputs
        wire [SEG_WIDTH-1:0] a_seg = a_pipe[i][i*SEG_WIDTH +: SEG_WIDTH];
        wire [SEG_WIDTH-1:0] b_seg = b_pipe[i][i*SEG_WIDTH +: SEG_WIDTH];
        
        // Carry-propagate and generate
        assign seg_propagate[i] = (a_seg == ~b_seg);  // P = A XOR B
        assign seg_generate[i] = (&(a_seg | ~b_seg)); // G = A AND B
        
        // Skip logic: carry_out = G or (P and carry_in)
        wire skip_carry = seg_generate[i] || (seg_propagate[i] && carry_chain[i]);
        assign carry_chain[i+1] = (i == 0) ? carry_chain[i] : skip_carry;
        
        // Segment sum
        assign seg_sum[i] = {1'b0, a_seg} + {1'b0, b_seg} + carry_chain[i];
    end
endgenerate

// Pipeline processing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int j = 0; j < NUM_SEG; j = j + 1) begin
            a_pipe[j] <= 64'b0;
            b_pipe[j] <= 64'b0;
        end
        carry_pipe <= '0;
        en_shift_reg <= '0;
        result <= '0;
        o_en <= 1'b0;
    end else begin
        // Shift enable through pipeline
        en_shift_reg <= {en_shift_reg[PIPELINE_STAGES-2:0], i_en};
        
        // First pipeline stage - register inputs
        a_pipe[0] <= adda;
        b_pipe[0] <= addb;
        carry_pipe[0] <= 1'b0;  // Initial carry in
        
        // Intermediate pipeline stages
        for (int j = 1; j < NUM_SEG; j = j + 1) begin
            a_pipe[j] <= a_pipe[j-1];
            b_pipe[j] <= b_pipe[j-1];
            carry_pipe[j] <= carry_chain[j];
        end
        
        // Output stage
        if (en_shift_reg[PIPELINE_STAGES-1]) begin
            // Combine all segment results
            result[64] <= carry_chain[NUM_SEG];  // Final carry out
            for (int j = 0; j < NUM_SEG; j = j + 1) begin
                result[j*SEG_WIDTH +: SEG_WIDTH] <= seg_sum[j][SEG_WIDTH-1:0];
            end
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule