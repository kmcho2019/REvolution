module adder_pipe_64bit (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         i_en,
    input  wire [63:0]  adda,
    input  wire [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // Pipeline parameters
    localparam STAGE_WIDTH = 16;
    localparam NUM_STAGES  = 4;

    // Stage input registers
    reg [STAGE_WIDTH-1:0] adda_reg [0:NUM_STAGES-1];
    reg [STAGE_WIDTH-1:0] addb_reg [0:NUM_STAGES-1];

    // Sum registers
    reg [STAGE_WIDTH-1:0] sum_reg [0:NUM_STAGES-1];

    // Carry registers: carry between stages (carry[0] is carry-in to stage 0)
    reg carry [0:NUM_STAGES];

    // Pipeline shift register for enable signal
    reg [NUM_STAGES:0] en_pipe;

    integer i;

    // Combinational slices of adda and addb
    wire [STAGE_WIDTH-1:0] adda_slices [0:NUM_STAGES-1];
    wire [STAGE_WIDTH-1:0] addb_slices [0:NUM_STAGES-1];

    generate
        genvar idx;
        for (idx = 0; idx < NUM_STAGES; idx = idx + 1) begin : slice_inputs
            assign adda_slices[idx] = adda[STAGE_WIDTH*idx +: STAGE_WIDTH];
            assign addb_slices[idx] = addb[STAGE_WIDTH*idx +: STAGE_WIDTH];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                adda_reg[i] <= 0;
                addb_reg[i] <= 0;
                sum_reg[i]  <= 0;
            end
            for (i = 0; i <= NUM_STAGES; i = i + 1) begin
                carry[i] <= 1'b0;
            end
            en_pipe <= 0;
            result <= 0;
            o_en <= 1'b0;
        end else begin
            // Shift input enable through pipeline stages
            en_pipe <= {en_pipe[NUM_STAGES-1:0], i_en};

            // Stage 0 input and carry-in
            if (i_en) begin
                adda_reg[0] <= adda_slices[0];
                addb_reg[0] <= addb_slices[0];
                carry[0]    <= 1'b0; // no carry-in for first stage
            end

            // Stage 0 sum and carry-out
            sum_reg[0] <= adda_reg[0] + addb_reg[0] + carry[0];
            carry[1]   <= (adda_reg[0] + addb_reg[0] + carry[0]) > 16'hFFFF;

            // Stages 1 to 3
            for (i = 1; i < NUM_STAGES; i = i + 1) begin
                if (en_pipe[i]) begin
                    adda_reg[i] <= adda_slices[i];
                    addb_reg[i] <= addb_slices[i];
                end
                sum_reg[i] <= adda_reg[i] + addb_reg[i] + carry[i];
                carry[i+1] <= (adda_reg[i] + addb_reg[i] + carry[i]) > 16'hFFFF;
            end

            // Output assembly and output enable
            if (en_pipe[NUM_STAGES]) begin
                result <= {carry[NUM_STAGES], sum_reg[3], sum_reg[2], sum_reg[1], sum_reg[0]};
            end

            o_en <= en_pipe[NUM_STAGES];
        end
    end

endmodule