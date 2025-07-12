module adder_pipe_64bit #(
    parameter DATA_WIDTH  = 64,
    parameter STAGE_WIDTH = 16,
    parameter NUM_STAGES  = DATA_WIDTH / STAGE_WIDTH
)(
    input  wire                   clk,
    input  wire                   rst_n,
    input  wire                   i_en,
    input  wire [DATA_WIDTH-1:0] adda,
    input  wire [DATA_WIDTH-1:0] addb,
    output reg  [DATA_WIDTH:0]   result,
    output reg                   o_en
);

    // Pipeline registers to hold latched inputs at stage 0
    reg [DATA_WIDTH-1:0] adda_stage0, addb_stage0;

    // Carry registers: one per stage plus one for initial carry-in (stage -1)
    reg [NUM_STAGES:0] carry; 
    // carry[0] is initial carry-in, carry[i] is carry-out of stage i-1
    
    // Partial sums registered per stage
    reg [STAGE_WIDTH-1:0] sum_reg [0:NUM_STAGES-1];

    // Enable shift register to track valid data through pipeline stages
    reg [NUM_STAGES:0] en_pipe;

    integer i;

    // Combinational partial sums and carry-outs per stage
    wire [STAGE_WIDTH-1:0] sum_comb [0:NUM_STAGES-1];
    wire carry_out_comb [0:NUM_STAGES-1];

    // Slice inputs from latched operands for each stage
    wire [STAGE_WIDTH-1:0] adda_slice [0:NUM_STAGES-1];
    wire [STAGE_WIDTH-1:0] addb_slice [0:NUM_STAGES-1];

    generate
        genvar gi;
        for (gi=0; gi<NUM_STAGES; gi=gi+1) begin : SLICE_INPUTS
            assign adda_slice[gi] = adda_stage0[gi*STAGE_WIDTH +: STAGE_WIDTH];
            assign addb_slice[gi] = addb_stage0[gi*STAGE_WIDTH +: STAGE_WIDTH];
        end
    endgenerate

    // Generate combinational sum and carry-out for each stage
    generate
        for (gi=0; gi<NUM_STAGES; gi=gi+1) begin : ADD_COMB
            assign {carry_out_comb[gi], sum_comb[gi]} = adda_slice[gi] + addb_slice[gi] + carry[gi];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_stage0 <= {DATA_WIDTH{1'b0}};
            addb_stage0 <= {DATA_WIDTH{1'b0}};
            carry       <= {(NUM_STAGES+1){1'b0}};
            en_pipe     <= {(NUM_STAGES+1){1'b0}};
            result      <= {(DATA_WIDTH+1){1'b0}};
            o_en        <= 1'b0;
            for (i=0; i<NUM_STAGES; i=i+1) sum_reg[i] <= {STAGE_WIDTH{1'b0}};
        end else begin
            // Latch inputs only when i_en is asserted
            if (i_en) begin
                adda_stage0 <= adda;
                addb_stage0 <= addb;
            end

            // Shift enable pipeline
            en_pipe <= {en_pipe[NUM_STAGES-1:0], i_en};

            // Update carry registers:
            // carry[0] is initial carry-in = 0 when new data arrives
            if (i_en)
                carry[0] <= 1'b0;
            else
                carry[0] <= carry[0]; // hold if no new input

            // For stages 0..NUM_STAGES-1:
            // Register carry-out from combinational adders as next stage's carry-in
            for (i=0; i<NUM_STAGES; i=i+1) begin
                carry[i+1] <= carry_out_comb[i];
            end

            // Register sums per stage
            for (i=0; i<NUM_STAGES; i=i+1) begin
                sum_reg[i] <= sum_comb[i];
            end

            // When data emerges at the output pipeline stage (en_pipe[NUM_STAGES]=1),
            // assemble and register the full output result
            if (en_pipe[NUM_STAGES]) begin
                result <= {carry[NUM_STAGES], 
                           sum_reg[NUM_STAGES-1],
                           sum_reg[NUM_STAGES-2],
                           sum_reg[NUM_STAGES-3],
                           sum_reg[NUM_STAGES-4]};
            end else begin
                // Hold previous result when output not valid
                result <= result;
            end

            // Output enable follows pipeline
            o_en <= en_pipe[NUM_STAGES];
        end
    end

    // Assemble result in a generate block for arbitrary NUM_STAGES:
    // Note: This combinational block reads sum_reg, which are registers.
    // To avoid inferred latches or combinational loops, the code above assembles result inside always block.
    // Below is an alternative for truly arbitrary NUM_STAGES (commented out):

    /*
    reg [DATA_WIDTH-1:0] sum_assembled;
    always @(*) begin
        sum_assembled = {DATA_WIDTH{1'b0}};
        for (i=0; i<NUM_STAGES; i=i+1) begin
            sum_assembled[i*STAGE_WIDTH +: STAGE_WIDTH] = sum_reg[i];
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            if (en_pipe[NUM_STAGES]) begin
                result <= {carry[NUM_STAGES], sum_assembled};
            end
            o_en <= en_pipe[NUM_STAGES];
        end
    end
    */

endmodule