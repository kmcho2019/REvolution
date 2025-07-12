module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output wire [64:0] result,
    output wire o_en
);

// Pipeline stage parameters
localparam STAGES = 4;
localparam STG_WIDTH = 16;

// Pipeline registers
reg [STG_WIDTH-1:0] a_pipe [0:STAGES-1];
reg [STG_WIDTH-1:0] b_pipe [0:STAGES-1];
reg [STAGES-2:0] carry_pipe;  // Carry between stages
reg [STAGES-1:0] en_pipe;     // Enable pipeline

// Intermediate sums and carries
wire [STG_WIDTH:0] stage_sum [0:STAGES-1];

// Generate pipeline stages
genvar i;
generate
    for (i = 0; i < STAGES; i = i + 1) begin : pipeline
        if (i == 0) begin
            // First stage has no carry input
            assign stage_sum[i] = {1'b0, a_pipe[i]} + {1'b0, b_pipe[i]};
        end else begin
            // Subsequent stages use carry from previous stage
            assign stage_sum[i] = {1'b0, a_pipe[i]} + {1'b0, b_pipe[i]} + 
                                {{(STG_WIDTH){1'b0}}, carry_pipe[i-1]};
        end
    end
endgenerate

// Result calculation
assign result = {
    stage_sum[3][STG_WIDTH],  // Final carry
    stage_sum[3][STG_WIDTH-1:0],  // Bits [63:48]
    stage_sum[2][STG_WIDTH-1:0],  // Bits [47:32]
    stage_sum[1][STG_WIDTH-1:0],  // Bits [31:16]
    stage_sum[0][STG_WIDTH-1:0]   // Bits [15:0]
};

// Output enable
assign o_en = en_pipe[STAGES-1];

// Pipeline registers update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Clear all pipeline registers
        for (integer j = 0; j < STAGES; j = j + 1) begin
            a_pipe[j] <= 0;
            b_pipe[j] <= 0;
        end
        carry_pipe <= 0;
        en_pipe <= 0;
    end else begin
        // Stage 0 input registers
        a_pipe[0] <= adda[0*STG_WIDTH +: STG_WIDTH];
        b_pipe[0] <= addb[0*STG_WIDTH +: STG_WIDTH];
        
        // Stage 1 input registers
        a_pipe[1] <= adda[1*STG_WIDTH +: STG_WIDTH];
        b_pipe[1] <= addb[1*STG_WIDTH +: STG_WIDTH];
        
        // Stage 2 input registers
        a_pipe[2] <= adda[2*STG_WIDTH +: STG_WIDTH];
        b_pipe[2] <= addb[2*STG_WIDTH +: STG_WIDTH];
        
        // Stage 3 input registers
        a_pipe[3] <= adda[3*STG_WIDTH +: STG_WIDTH];
        b_pipe[3] <= addb[3*STG_WIDTH +: STG_WIDTH];
        
        // Carry propagation
        carry_pipe[0] <= stage_sum[0][STG_WIDTH];
        carry_pipe[1] <= stage_sum[1][STG_WIDTH];
        carry_pipe[2] <= stage_sum[2][STG_WIDTH];
        
        // Enable signal pipeline
        en_pipe <= {en_pipe[STAGES-2:0], i_en};
    end
end

endmodule