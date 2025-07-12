module adder_pipe_64bit (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         i_en,
    input  wire [63:0]  adda,
    input  wire [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // Parameters for flexibility
    localparam STAGE_WIDTH = 16;
    localparam NUM_STAGES  = 4;

    // Pipeline registers for operands
    reg [STAGE_WIDTH-1:0] adda_reg [0:NUM_STAGES-1];
    reg [STAGE_WIDTH-1:0] addb_reg [0:NUM_STAGES-1];

    // Carry registers between stages: carry_in for stage i stored in carry_reg[i]
    reg carry_reg [0:NUM_STAGES];

    // Sum registers for each stage
    reg [STAGE_WIDTH-1:0] sum_reg [0:NUM_STAGES-1];

    // Enable pipeline shift register for synchronization of o_en
    reg [NUM_STAGES:0] en_pipe;

    integer i;

    // Wires to hold sum and carry-out for each stage (combinational for clarity)
    wire [STAGE_WIDTH:0] add_stage_sum [0:NUM_STAGES-1]; // STAGE_WIDTH+1 bits to hold carry-out MSB

    // Slice input operands into 16-bit parts
    wire [STAGE_WIDTH-1:0] adda_slices [0:NUM_STAGES-1];
    wire [STAGE_WIDTH-1:0] addb_slices [0:NUM_STAGES-1];

    genvar idx;
    generate
        for (idx = 0; idx < NUM_STAGES; idx = idx + 1) begin : gen_input_slices
            assign adda_slices[idx] = adda[STAGE_WIDTH*idx +: STAGE_WIDTH];
            assign addb_slices[idx] = addb[STAGE_WIDTH*idx +: STAGE_WIDTH];
        end
    endgenerate

    // Compute sum and carry-out for each stage based on registered inputs and carry_in
    generate
        for (idx = 0; idx < NUM_STAGES; idx = idx + 1) begin : gen_add_stage
            assign add_stage_sum[idx] = adda_reg[idx] + addb_reg[idx] + carry_reg[idx];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset pipeline registers
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                adda_reg[i] <= {STAGE_WIDTH{1'b0}};
                addb_reg[i] <= {STAGE_WIDTH{1'b0}};
                sum_reg[i]  <= {STAGE_WIDTH{1'b0}};
                carry_reg[i] <= 1'b0;
            end
            carry_reg[NUM_STAGES] <= 1'b0;
            en_pipe <= {(NUM_STAGES+1){1'b0}};
            result <= {(STAGE_WIDTH*NUM_STAGES +1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Shift enable pipeline
            en_pipe <= {en_pipe[NUM_STAGES-1:0], i_en};

            // Stage 0: capture inputs and initial carry_in=0 when i_en is high
            if (i_en) begin
                adda_reg[0] <= adda_slices[0];
                addb_reg[0] <= addb_slices[0];
                carry_reg[0] <= 1'b0;
            end

            // Compute sum and carry_out for stage 0 (registered from previous cycle)
            sum_reg[0] <= add_stage_sum[0][STAGE_WIDTH-1:0];
            carry_reg[1] <= add_stage_sum[0][STAGE_WIDTH]; // carry-out to next stage

            // Subsequent stages
            for (i = 1; i < NUM_STAGES; i = i + 1) begin
                if (en_pipe[i]) begin
                    // Register operands from input slices only when corresponding enable is high
                    adda_reg[i] <= adda_slices[i];
                    addb_reg[i] <= addb_slices[i];
                end
                // Register sum and carry-out based on previously registered inputs and carry_in
                sum_reg[i] <= add_stage_sum[i][STAGE_WIDTH-1:0];
                carry_reg[i+1] <= add_stage_sum[i][STAGE_WIDTH];
            end

            // When the final pipeline stage output is ready, assemble result
            if (en_pipe[NUM_STAGES]) begin
                // Concatenate carry_out (carry_reg[NUM_STAGES]) and all sums in order
                result <= {carry_reg[NUM_STAGES],
                           sum_reg[NUM_STAGES-1],
                           sum_reg[NUM_STAGES-2],
                           sum_reg[NUM_STAGES-3],
                           sum_reg[0]};
            end

            // Output enable delayed through pipeline stages
            o_en <= en_pipe[NUM_STAGES];
        end
    end

endmodule