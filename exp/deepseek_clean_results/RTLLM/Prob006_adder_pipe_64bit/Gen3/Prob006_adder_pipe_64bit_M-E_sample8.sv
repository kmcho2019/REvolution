module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Parameters
localparam BLOCK_SIZE = 16;
localparam NUM_BLOCKS = 4;
localparam MAX_PIPE_DEPTH = 3;

// Block signals
wire [BLOCK_SIZE:0] block_sum [0:NUM_BLOCKS-1];
wire [NUM_BLOCKS:0] block_carry;
wire [NUM_BLOCKS-1:0] block_propagate;

// Pipeline registers
reg [63:0] adda_pipe [0:MAX_PIPE_DEPTH-1];
reg [63:0] addb_pipe [0:MAX_PIPE_DEPTH-1];
reg [MAX_PIPE_DEPTH-1:0] pipe_valid;
reg [1:0] pipe_stage [0:MAX_PIPE_DEPTH-1]; // Tracks computation stage

// Carry prediction unit
reg [NUM_BLOCKS:0] predicted_carry;
reg carry_pred_valid;

// Token tracking
reg [2:0] token_pos; // Tracks computation progress

// Generate blocks
genvar i;
generate
    for (i = 0; i < NUM_BLOCKS; i = i + 1) begin : ADDER_BLOCKS
        // Block adder with carry-skip logic
        assign block_sum[i] = {1'b0, adda_pipe[0][i*BLOCK_SIZE +: BLOCK_SIZE]} + 
                             {1'b0, addb_pipe[0][i*BLOCK_SIZE +: BLOCK_SIZE]} + 
                             block_carry[i];
        
        // Block propagate signal
        assign block_propagate[i] = &(adda_pipe[0][i*BLOCK_SIZE +: BLOCK_SIZE] | 
                                    addb_pipe[0][i*BLOCK_SIZE +: BLOCK_SIZE]);
    end
endgenerate

// Carry chain with skip logic
assign block_carry[0] = 1'b0;
generate
    for (i = 1; i <= NUM_BLOCKS; i = i + 1) begin : CARRY_CHAIN
        // Skip logic: if all previous blocks propagate, carry skips forward
        assign block_carry[i] = (i == token_pos[2:1]+1) ? 
                               (block_propagate[i-1] ? block_carry[i-1] : 
                                block_sum[i-1][BLOCK_SIZE]) : 
                               predicted_carry[i];
    end
endgenerate

// Dynamic pipeline control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int j = 0; j < MAX_PIPE_DEPTH; j++) begin
            adda_pipe[j] <= 64'b0;
            addb_pipe[j] <= 64'b0;
            pipe_valid[j] <= 1'b0;
            pipe_stage[j] <= 2'b0;
        end
        predicted_carry <= {(NUM_BLOCKS+1){1'b0}};
        carry_pred_valid <= 1'b0;
        token_pos <= 3'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Input stage
        adda_pipe[0] <= adda;
        addb_pipe[0] <= addb;
        pipe_valid[0] <= i_en;
        pipe_stage[0] <= 2'b0;
        
        // Pipeline propagation
        for (int j = 1; j < MAX_PIPE_DEPTH; j++) begin
            adda_pipe[j] <= adda_pipe[j-1];
            addb_pipe[j] <= addb_pipe[j-1];
            pipe_valid[j] <= pipe_valid[j-1];
            pipe_stage[j] <= pipe_stage[j-1] + (pipe_stage[j-1] != 2'b11);
        end
        
        // Carry prediction update
        if (pipe_valid[0] && pipe_stage[0] == 0) begin
            predicted_carry <= block_carry;
            carry_pred_valid <= 1'b1;
        end
        
        // Token position update
        if (pipe_valid[0]) begin
            token_pos <= token_pos + 1;
            if (token_pos == MAX_PIPE_DEPTH-1) token_pos <= 0;
        end
        
        // Output generation
        if (pipe_valid[MAX_PIPE_DEPTH-1] && pipe_stage[MAX_PIPE_DEPTH-1] == 2'b11) begin
            result <= {block_carry[NUM_BLOCKS], 
                      block_sum[3][BLOCK_SIZE-1:0],
                      block_sum[2][BLOCK_SIZE-1:0],
                      block_sum[1][BLOCK_SIZE-1:0],
                      block_sum[0][BLOCK_SIZE-1:0]};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

// Early result speculation
always @(*) begin
    if (carry_pred_valid) begin
        // Speculative result using predicted carries
        result = {predicted_carry[NUM_BLOCKS],
                 block_sum[3][BLOCK_SIZE-1:0],
                 block_sum[2][BLOCK_SIZE-1:0],
                 block_sum[1][BLOCK_SIZE-1:0],
                 block_sum[0][BLOCK_SIZE-1:0]};
    end
end

endmodule