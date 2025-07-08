module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  reg [64:0] result,
    output  reg      o_en
);

    // Pipeline configuration:
    // Split 64-bit adder into 4 stages of 16 bits each.
    // Each stage adds 16 bits + carry_in and outputs sum and carry_out.
    // Pipeline registers between stages store partial sums and carry.
    // Also pipeline i_en through 4 stages.

    localparam STAGES = 4;
    localparam STAGE_WIDTH = 16;

    // Pipeline registers for operands segments
    reg [STAGE_WIDTH-1:0] adda_pipe [0:STAGES-1];
    reg [STAGE_WIDTH-1:0] addb_pipe [0:STAGES-1];

    // Pipeline registers for carry
    reg carry_pipe [0:STAGES]; // carry_pipe[0] is carry_in to stage 0 (zero)

    // Pipeline registers for partial sum segments
    reg [STAGE_WIDTH-1:0] sum_pipe [0:STAGES-1];

    // Pipeline register for output enable signal
    reg [STAGES:0] o_en_pipe;

    integer i;

    // Initialize carry_in to zero for first stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            carry_pipe[0] <= 1'b0;
            o_en_pipe <= {(STAGES+1){1'b0}};
            result <= 0;
            o_en <= 1'b0;
            for (i = 0; i < STAGES; i=i+1) begin
                adda_pipe[i] <= 0;
                addb_pipe[i] <= 0;
                sum_pipe[i] <= 0;
                carry_pipe[i+1] <= 0;
            end
        end else begin
            // Shift input operands through pipeline registers
            // On i_en, latch input operands into stage 0
            if (i_en) begin
                adda_pipe[0] <= adda[15:0];
                addb_pipe[0] <= addb[15:0];
            end else begin
                adda_pipe[0] <= 0;
                addb_pipe[0] <= 0;
            end

            // Shift remaining operand segments through pipeline
            for (i = 1; i < STAGES; i=i+1) begin
                adda_pipe[i] <= adda[(i+1)*STAGE_WIDTH-1 -: STAGE_WIDTH];
                addb_pipe[i] <= addb[(i+1)*STAGE_WIDTH-1 -: STAGE_WIDTH];
            end

            // Pipeline the carry_in and calculate sum and carry_out per stage
            // Stage 0 carry_in is 0
            carry_pipe[0] <= 1'b0;

            // Calculate sum and carry per stage
            // Since it is a ripple carry, carry_out of previous stage feeds next stage
            // We need to compute sums and carry in pipeline order:

            // Stage 0 sum and carry
            {carry_pipe[1], sum_pipe[0]} <= adda_pipe[0] + addb_pipe[0] + carry_pipe[0];

            // Stage 1 sum and carry
            {carry_pipe[2], sum_pipe[1]} <= adda_pipe[1] + addb_pipe[1] + carry_pipe[1];

            // Stage 2 sum and carry
            {carry_pipe[3], sum_pipe[2]} <= adda_pipe[2] + addb_pipe[2] + carry_pipe[2];

            // Stage 3 sum and carry
            {carry_pipe[4], sum_pipe[3]} <= adda_pipe[3] + addb_pipe[3] + carry_pipe[3];

            // Pipeline the output enable signal through STAGES+1 registers to match latency
            o_en_pipe <= {o_en_pipe[STAGES-1:0], i_en};

            // When output enable pipe last bit is high, output the final result
            if (o_en_pipe[STAGES]) begin
                result <= {carry_pipe[4], sum_pipe[3], sum_pipe[2], sum_pipe[1], sum_pipe[0]};
                o_en <= 1'b1;
            end else begin
                result <= result;
                o_en <= 1'b0;
            end
        end
    end

endmodule