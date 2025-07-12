module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 16
)(
    input  wire                   clk,
    input  wire                   rst_n,
    input  wire                   i_en,
    input  wire [DATA_WIDTH-1:0] adda,
    input  wire [DATA_WIDTH-1:0] addb,
    output reg  [DATA_WIDTH:0]   result,
    output reg                   o_en
);

    localparam NUM_STAGES = DATA_WIDTH / STG_WIDTH;

    // Pipeline registers for operand slices per stage
    reg [STG_WIDTH-1:0] adda_pipe  [0:NUM_STAGES-1];
    reg [STG_WIDTH-1:0] addb_pipe  [0:NUM_STAGES-1];

    // Pipeline registers for sum per stage
    reg [STG_WIDTH-1:0] sum_pipe   [0:NUM_STAGES-1];

    // Pipeline registers for carry per stage
    // carry_pipe[i] is the carry-in to stage i (0-based), width=1 bit
    // carry_pipe[0] is always 0 on new input
    reg carry_pipe [0:NUM_STAGES];

    // Pipeline register for enable signal to track data validity across stages
    reg [NUM_STAGES:0] en_pipe;

    integer i;

    // Slice inputs for all stages
    wire [STG_WIDTH-1:0] adda_slices [0:NUM_STAGES-1];
    wire [STG_WIDTH-1:0] addb_slices [0:NUM_STAGES-1];

    genvar idx;
    generate
        for (idx=0; idx<NUM_STAGES; idx=idx+1) begin : input_slices
            assign adda_slices[idx] = adda[STG_WIDTH*idx +: STG_WIDTH];
            assign addb_slices[idx] = addb[STG_WIDTH*idx +: STG_WIDTH];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            for (i=0; i<NUM_STAGES; i=i+1) begin
                adda_pipe[i]  <= {STG_WIDTH{1'b0}};
                addb_pipe[i]  <= {STG_WIDTH{1'b0}};
                sum_pipe[i]   <= {STG_WIDTH{1'b0}};
            end
            for (i=0; i<=NUM_STAGES; i=i+1) begin
                carry_pipe[i] <= 1'b0;
            end
            en_pipe <= {(NUM_STAGES+1){1'b0}};
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Shift enable pipeline to track valid data at output
            en_pipe <= {en_pipe[NUM_STAGES-1:0], i_en};

            // Stage 0: load input slices when i_en asserted
            if (i_en) begin
                adda_pipe[0] <= adda_slices[0];
                addb_pipe[0] <= addb_slices[0];
                carry_pipe[0] <= 1'b0;  // no carry-in at stage 0 for new input
            end else begin
                // Hold previous values if no new input enable
                adda_pipe[0] <= adda_pipe[0];
                addb_pipe[0] <= addb_pipe[0];
                carry_pipe[0] <= carry_pipe[0];
            end

            // For stages 1 to NUM_STAGES-1: register inputs and carry from previous stage
            for (i=1; i<NUM_STAGES; i=i+1) begin
                if (en_pipe[i]) begin
                    adda_pipe[i] <= adda_slices[i];
                    addb_pipe[i] <= addb_slices[i];
                end else begin
                    // Hold previous values
                    adda_pipe[i] <= adda_pipe[i];
                    addb_pipe[i] <= addb_pipe[i];
                end
                carry_pipe[i] <= carry_pipe[i]; // carry_pipe[i] will be updated below
            end

            // Calculate sums and carry for each stage from previous cycle's data
            // Note: sums and carry-out are registered in this clock cycle after inputs/carry registered
            // Pipeline implements one stage addition per clock cycle
            for (i=0; i<NUM_STAGES; i=i+1) begin
                // Non-blocking assignment to pipeline sum and carry-out (carry_pipe[i+1])
                {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
            end

            // When last stage's output is valid, assemble the full result
            if (en_pipe[NUM_STAGES]) begin
                // Concatenate sums and final carry-out
                // sum_pipe[0] is LSB stage, sum_pipe[NUM_STAGES-1] is MSB stage
                result <= {carry_pipe[NUM_STAGES], 
                           sum_pipe[NUM_STAGES-1], 
                           sum_pipe[NUM_STAGES-2], 
                           sum_pipe[NUM_STAGES-3], 
                           sum_pipe[0]};
                // The above concatenation lists only 4 stages explicitly for clarity, 
                // generalize below:
            end else begin
                result <= result;
            end

            o_en <= en_pipe[NUM_STAGES];
        end
    end

    // Generalize result concatenation for arbitrary NUM_STAGES
    // Use a combinational function to concatenate sums in order
    // and assign result in the clocked always block above
    // Create an internal wire for concatenation
    wire [DATA_WIDTH-1:0] sum_concat;
    reg [DATA_WIDTH-1:0] sum_concat_reg;

    integer j;
    always @* begin
        sum_concat_reg = {(DATA_WIDTH){1'b0}};
        for (j = 0; j < NUM_STAGES; j = j +1) begin
            sum_concat_reg[STG_WIDTH*j +: STG_WIDTH] = sum_pipe[j];
        end
    end

    assign sum_concat = sum_concat_reg;

    // Replace the earlier result assignment with general concatenation:
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= {(DATA_WIDTH+1){1'b0}};
        end else if (en_pipe[NUM_STAGES]) begin
            result <= {carry_pipe[NUM_STAGES], sum_concat};
        end
    end

endmodule