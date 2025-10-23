module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Configurable parameters
localparam SEG_WIDTH = 8;    // Bits per segment
localparam NUM_SEG = 8;      // Number of segments (64/8)
localparam PIPELINE_STAGES = 3;

// Pipeline registers
reg [63:0] a_pipe [0:PIPELINE_STAGES-1];
reg [63:0] b_pipe [0:PIPELINE_STAGES-1];
reg [NUM_SEG:0] carry_pipe [0:PIPELINE_STAGES-1];
reg [SEG_WIDTH-1:0] sum0_0_pipe [0:NUM_SEG-1][0:PIPELINE_STAGES-1];
reg [SEG_WIDTH-1:0] sum0_1_pipe [0:NUM_SEG-1][0:PIPELINE_STAGES-1];
reg [SEG_WIDTH-1:0] final_sum [0:NUM_SEG-1];

// Enable signal pipeline
reg [PIPELINE_STAGES:0] en_pipe;

// Combinational precomputed sums
wire [SEG_WIDTH-1:0] sum0_0 [0:NUM_SEG-1];
wire [SEG_WIDTH-1:0] sum0_1 [0:NUM_SEG-1];

// Generate precomputed sums for each segment
genvar i;
generate
    for (i = 0; i < NUM_SEG; i = i + 1) begin : SEG_PRECOMP
        assign sum0_0[i] = adda[i*SEG_WIDTH +: SEG_WIDTH] + addb[i*SEG_WIDTH +: SEG_WIDTH];
        assign sum0_1[i] = adda[i*SEG_WIDTH +: SEG_WIDTH] + addb[i*SEG_WIDTH +: SEG_WIDTH] + 1'b1;
    end
endgenerate

// Carry propagation logic
always @(*) begin
    carry_pipe[0][0] = 1'b0;  // Initial carry-in
    
    for (integer j = 0; j < NUM_SEG; j = j + 1) begin
        // Carry-out = G + P·Cin
        carry_pipe[0][j+1] = ((a_pipe[0][j*SEG_WIDTH +: SEG_WIDTH] & b_pipe[0][j*SEG_WIDTH +: SEG_WIDTH]) |
                             ((a_pipe[0][j*SEG_WIDTH +: SEG_WIDTH] | b_pipe[0][j*SEG_WIDTH +: SEG_WIDTH]) & 
                              carry_pipe[0][j]));
        
        // Select sum based on carry-in
        final_sum[j] = carry_pipe[0][j] ? sum0_1_pipe[j][0] : sum0_0_pipe[j][0];
    end
end

// Pipeline registers and control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear all pipeline registers
        for (integer k = 0; k < PIPELINE_STAGES; k = k + 1) begin
            a_pipe[k] <= 64'b0;
            b_pipe[k] <= 64'b0;
            carry_pipe[k] <= {(NUM_SEG+1){1'b0}};
            
            for (integer m = 0; m < NUM_SEG; m = m + 1) begin
                sum0_0_pipe[m][k] <= {SEG_WIDTH{1'b0}};
                sum0_1_pipe[m][k] <= {SEG_WIDTH{1'b0}};
            end
        end
        
        en_pipe <= {(PIPELINE_STAGES+1){1'b0}};
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 1: Input registers and precomputation
        a_pipe[0] <= adda;
        b_pipe[0] <= addb;
        for (integer m = 0; m < NUM_SEG; m = m + 1) begin
            sum0_0_pipe[m][0] <= sum0_0[m];
            sum0_1_pipe[m][0] <= sum0_1[m];
        end
        
        // Stage 2: Carry propagation
        a_pipe[1] <= a_pipe[0];
        b_pipe[1] <= b_pipe[0];
        carry_pipe[1] <= carry_pipe[0];
        for (integer m = 0; m < NUM_SEG; m = m + 1) begin
            sum0_0_pipe[m][1] <= sum0_0_pipe[m][0];
            sum0_1_pipe[m][1] <= sum0_1_pipe[m][0];
        end
        
        // Stage 3: Final sum assembly
        a_pipe[2] <= a_pipe[1];
        b_pipe[2] <= b_pipe[1];
        carry_pipe[2] <= carry_pipe[1];
        
        // Pipeline enable signals
        en_pipe <= {en_pipe[PIPELINE_STAGES-1:0], i_en};
        
        // Output stage
        if (en_pipe[PIPELINE_STAGES]) begin
            result <= {carry_pipe[2][NUM_SEG], 
                      final_sum[7], final_sum[6], final_sum[5], final_sum[4],
                      final_sum[3], final_sum[2], final_sum[1], final_sum[0]};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule