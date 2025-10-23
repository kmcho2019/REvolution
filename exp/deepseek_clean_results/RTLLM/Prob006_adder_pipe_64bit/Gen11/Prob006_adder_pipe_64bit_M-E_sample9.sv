module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output wire [64:0] result,
    output wire o_en
);

// Pipeline parameters
localparam SEGMENTS = 8;
localparam BITS_PER_SEG = 8;
localparam PIPELINE_STAGES = 3;

// Pipeline registers
reg [63:0] adda_pipe [0:PIPELINE_STAGES-1];
reg [63:0] addb_pipe [0:PIPELINE_STAGES-1];
reg [SEGMENTS:0] carry_pipe [0:PIPELINE_STAGES-1];
reg [2:0] enable_pipe;

// Intermediate signals
wire [BITS_PER_SEG:0] seg_sum [0:SEGMENTS-1];
wire [SEGMENTS:0] carry_chain;
reg [64:0] partial_sum [0:PIPELINE_STAGES-1];

// Carry chain initialization
assign carry_chain[0] = 1'b0;

// Generate all segments
genvar i;
generate
    for (i = 0; i < SEGMENTS; i = i + 1) begin : segment
        // Current segment inputs (with carry select)
        wire [BITS_PER_SEG-1:0] a_seg = (i < 2) ? adda[i*BITS_PER_SEG +: BITS_PER_SEG] : 
                                       adda_pipe[0][i*BITS_PER_SEG +: BITS_PER_SEG];
        wire [BITS_PER_SEG-1:0] b_seg = (i < 2) ? addb[i*BITS_PER_SEG +: BITS_PER_SEG] : 
                                       addb_pipe[0][i*BITS_PER_SEG +: BITS_PER_SEG];
        
        // Carry-select addition
        wire [BITS_PER_SEG:0] sum_with_carry = {1'b0, a_seg} + {1'b0, b_seg} + 1'b1;
        wire [BITS_PER_SEG:0] sum_no_carry = {1'b0, a_seg} + {1'b0, b_seg};
        
        // Mux based on carry in
        assign seg_sum[i] = carry_chain[i] ? sum_with_carry : sum_no_carry;
        
        // Carry propagation
        assign carry_chain[i+1] = seg_sum[i][BITS_PER_SEG];
    end
endgenerate

// Pipeline registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear all pipeline registers
        for (integer j = 0; j < PIPELINE_STAGES; j = j + 1) begin
            adda_pipe[j] <= 64'b0;
            addb_pipe[j] <= 64'b0;
            carry_pipe[j] <= {(SEGMENTS+1){1'b0}};
            partial_sum[j] <= 65'b0;
        end
        enable_pipe <= 3'b0;
    end else begin
        // Stage 0 registers (first two segments)
        adda_pipe[0] <= adda;
        addb_pipe[0] <= addb;
        carry_pipe[0] <= carry_chain;
        partial_sum[0][15:0] <= {seg_sum[1][7:0], seg_sum[0][7:0]};
        
        // Stage 1 registers (next three segments)
        adda_pipe[1] <= adda_pipe[0];
        addb_pipe[1] <= addb_pipe[0];
        carry_pipe[1] <= carry_pipe[0];
        partial_sum[1][39:16] <= {seg_sum[4][7:0], seg_sum[3][7:0], seg_sum[2][7:0]};
        
        // Stage 2 registers (final three segments + combine)
        adda_pipe[2] <= adda_pipe[1];
        addb_pipe[2] <= addb_pipe[1];
        carry_pipe[2] <= carry_pipe[1];
        partial_sum[2] <= {carry_chain[SEGMENTS],
                          seg_sum[7][7:0], seg_sum[6][7:0], seg_sum[5][7:0],
                          partial_sum[1][39:16],
                          partial_sum[0][15:0]};
        
        // Enable pipeline
        enable_pipe <= {enable_pipe[1:0], i_en};
    end
end

// Output assignments
assign result = partial_sum[PIPELINE_STAGES-1];
assign o_en = enable_pipe[PIPELINE_STAGES-1];

endmodule