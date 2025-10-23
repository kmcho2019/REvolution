module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Constants
localparam CHUNK_SIZE = 16;
localparam NUM_CHUNKS = 4;

// Phase 1 Registers
reg [63:0] a_phase1, b_phase1;
reg [NUM_CHUNKS-1:0] en_phase1;

// Phase 1 Computation (Parallel chunk sums)
wire [CHUNK_SIZE:0] chunk_sum [NUM_CHUNKS-1:0];
wire [NUM_CHUNKS-1:0] chunk_carry;

generate
    for (genvar i = 0; i < NUM_CHUNKS; i = i + 1) begin : CHUNK_ADDER
        assign chunk_sum[i] = a_phase1[i*CHUNK_SIZE +: CHUNK_SIZE] + 
                            b_phase1[i*CHUNK_SIZE +: CHUNK_SIZE];
        // Carry-out from each chunk
        assign chunk_carry[i] = chunk_sum[i][CHUNK_SIZE];
    end
endgenerate

// Phase 2 Registers
reg [CHUNK_SIZE-1:0] sum_low_reg;
reg [47:0] sum_high_pending;
reg [NUM_CHUNKS-1:0] carries;
reg [1:0] en_phase2;

// Final Sum Computation
wire [48:0] final_sum = sum_high_pending + {carries[NUM_CHUNKS-2:0], 32'b0};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Phase 1 Reset
        a_phase1 <= 64'b0;
        b_phase1 <= 64'b0;
        en_phase1 <= 4'b0;
        
        // Phase 2 Reset
        sum_low_reg <= 16'b0;
        sum_high_pending <= 48'b0;
        carries <= 4'b0;
        en_phase2 <= 2'b0;
        
        // Output Reset
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Phase 1: Register inputs and compute chunk sums
        a_phase1 <= adda;
        b_phase1 <= addb;
        en_phase1 <= {en_phase1[NUM_CHUNKS-2:0], i_en};
        
        // Phase 2: Capture intermediate results
        if (en_phase1[NUM_CHUNKS-1]) begin
            sum_low_reg <= chunk_sum[0][CHUNK_SIZE-1:0];
            sum_high_pending <= {chunk_sum[3][CHUNK_SIZE-1:0], 
                                chunk_sum[2][CHUNK_SIZE-1:0], 
                                chunk_sum[1][CHUNK_SIZE-1:0]};
            carries <= chunk_carry;
            en_phase2 <= {en_phase2[0], 1'b1};
        end else begin
            en_phase2 <= {en_phase2[0], 1'b0};
        end
        
        // Output Formation
        if (en_phase2[1]) begin
            result <= {final_sum[48], 
                      final_sum[47:0], 
                      sum_low_reg};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule