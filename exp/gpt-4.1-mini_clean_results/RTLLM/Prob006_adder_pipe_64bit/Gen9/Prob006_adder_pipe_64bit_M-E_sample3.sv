module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input       [63:0]  adda,
    input       [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // Define 16-bit slice width and number of stages
    localparam STG_WIDTH = 16;
    localparam STAGES = 4; // 64 / 16

    // Pipeline registers for each stage inputs, sums, carry signals, and enable signals
    reg [STG_WIDTH-1:0] adda_pipe   [0:STAGES-1];
    reg [STG_WIDTH-1:0] addb_pipe   [0:STAGES-1];
    reg carry_pipe                 [0:STAGES];    // carry pipe from stage 0 to STAGES
    reg [STG_WIDTH-1:0] sum_pipe  [0:STAGES-1];
    reg en_pipe                   [0:STAGES];

    integer i;

    // Combinational addition for each stage
    wire [STG_WIDTH:0] sum_with_carry [0:STAGES-1];

    generate
        genvar stage_i;
        for(stage_i=0; stage_i<STAGES; stage_i=stage_i+1) begin : ADD_STAGE
            assign sum_with_carry[stage_i] = adda_pipe[stage_i] + addb_pipe[stage_i] + carry_pipe[stage_i];
        end
    endgenerate

    // Assemble result combinationally from sums and carry_out of last stage
    reg [64:0] sum_assembled;
    always @(*) begin
        sum_assembled = 65'b0;
        for(i=0; i<STAGES; i=i+1) begin
            sum_assembled[i*STG_WIDTH +: STG_WIDTH] = sum_pipe[i];
        end
        sum_assembled[64] = carry_pipe[STAGES];
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialize all pipeline registers
            for(i=0; i<STAGES; i=i+1) begin
                adda_pipe[i] <= 0;
                addb_pipe[i] <= 0;
                sum_pipe[i] <= 0;
                carry_pipe[i] <= 0;
                en_pipe[i] <= 0;
            end
            carry_pipe[STAGES] <= 0;
            en_pipe[STAGES] <= 0;
            result <= 0;
            o_en <= 0;
        end else begin
            // Stage 0: latch first 16 bits of inputs and carry-in=0
            adda_pipe[0] <= adda[15:0];
            addb_pipe[0] <= addb[15:0];
            carry_pipe[0] <= 1'b0;
            en_pipe[0] <= i_en;

            // Stages 1 to 3: latch inputs from corresponding input bits,
            // carry_in from previous stage carry_out, and en_pipe propagated
            for(i=1; i<STAGES; i=i+1) begin
                adda_pipe[i] <= adda[i*STG_WIDTH +: STG_WIDTH];
                addb_pipe[i] <= addb[i*STG_WIDTH +: STG_WIDTH];
                carry_pipe[i] <= sum_with_carry[i-1][STG_WIDTH]; // carry out from previous stage
                en_pipe[i] <= en_pipe[i-1];
            end

            // Capture sums for all stages
            for(i=0; i<STAGES; i=i+1) begin
                sum_pipe[i] <= sum_with_carry[i][STG_WIDTH-1:0];
            end

            // Final carry_out from last stage
            carry_pipe[STAGES] <= sum_with_carry[STAGES-1][STG_WIDTH];

            // Propagate enable signal one cycle further
            en_pipe[STAGES] <= en_pipe[STAGES-1];

            // Register output result and o_en at final pipeline stage
            result <= sum_assembled;
            o_en <= en_pipe[STAGES];
        end
    end

endmodule