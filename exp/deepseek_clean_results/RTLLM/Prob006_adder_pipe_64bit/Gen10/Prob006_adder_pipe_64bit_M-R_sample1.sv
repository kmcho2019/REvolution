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
localparam STAGES = 4;
localparam BITS_PER_STAGE = 16;

// Pipeline registers
reg [63:0] adda_reg [0:STAGES-1];
reg [63:0] addb_reg [0:STAGES-1];
reg [STAGES:0] enable_reg;

// Intermediate sums and carries
wire [BITS_PER_STAGE:0] stage_sum [0:STAGES-1];
reg [64:0] sum_reg [0:STAGES-1];
wire [STAGES:0] carry;

// Initialize carry chain
assign carry[0] = 1'b0;

// Generate pipeline stages
genvar i;
generate
    for (i = 0; i < STAGES; i = i + 1) begin : pipeline_stage
        // Slice of operands for this stage
        wire [BITS_PER_STAGE-1:0] a_slice = (i == 0) ? adda[BITS_PER_STAGE*i +: BITS_PER_STAGE] : 
                                            adda_reg[i-1][BITS_PER_STAGE*i +: BITS_PER_STAGE];
        wire [BITS_PER_STAGE-1:0] b_slice = (i == 0) ? addb[BITS_PER_STAGE*i +: BITS_PER_STAGE] : 
                                            addb_reg[i-1][BITS_PER_STAGE*i +: BITS_PER_STAGE];
        
        // Stage addition
        assign stage_sum[i] = {1'b0, a_slice} + {1'b0, b_slice} + carry[i];
        
        // Carry propagation
        assign carry[i+1] = stage_sum[i][BITS_PER_STAGE];
        
        // Register updates
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                adda_reg[i] <= 64'b0;
                addb_reg[i] <= 64'b0;
                sum_reg[i] <= 65'b0;
            end else begin
                // First stage gets direct inputs, others get registered values
                if (i == 0) begin
                    adda_reg[i] <= adda;
                    addb_reg[i] <= addb;
                end else begin
                    adda_reg[i] <= adda_reg[i-1];
                    addb_reg[i] <= addb_reg[i-1];
                end
                
                // Sum accumulation
                if (i < STAGES-1) begin
                    sum_reg[i][BITS_PER_STAGE*i +: BITS_PER_STAGE] <= stage_sum[i][BITS_PER_STAGE-1:0];
                end else begin
                    // Final stage combines all partial sums
                    sum_reg[i] <= {stage_sum[i][BITS_PER_STAGE], 
                                 sum_reg[i-1][63:BITS_PER_STAGE*(STAGES-1)], 
                                 stage_sum[i][BITS_PER_STAGE-1:0]};
                end
            end
        end
    end
endgenerate

// Enable signal pipeline
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        enable_reg <= {(STAGES+1){1'b0}};
    end else begin
        enable_reg <= {enable_reg[STAGES-1:0], i_en};
    end
end

// Output assignments
assign result = sum_reg[STAGES-1];
assign o_en = enable_reg[STAGES];

endmodule