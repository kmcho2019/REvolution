module adder_pipe_64bit (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         i_en,
    input  wire [63:0]  adda,
    input  wire [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // Parameters for pipeline stages and segment width
    localparam STAGES = 16;   // Number of pipeline stages
    localparam SEG_BITS = 4;  // Bits processed per stage

    // Registers to hold segments of operands at each pipeline stage
    reg [SEG_BITS-1:0] adda_pipe [0:STAGES-1];
    reg [SEG_BITS-1:0] addb_pipe [0:STAGES-1];
    reg carry_pipe [0:STAGES-1];       // Registered carry-in per stage
    reg [SEG_BITS-1:0] sum_pipe [0:STAGES-1]; // Registered sum per stage
    reg en_pipe [0:STAGES-1];          // Pipeline enable flags

    integer i;

    // Combinational wires for carry-out and sum before register at each stage
    wire [SEG_BITS-1:0] sum_comb [0:STAGES-1];
    wire carry_out_comb [0:STAGES-1];

    // Generate combinational adders per stage: sum and carry-out
    generate
        genvar stage;
        for(stage=0; stage < STAGES; stage=stage+1) begin : adder_stage
            wire [SEG_BITS-1:0] a = (stage==0) ? adda[SEG_BITS*0 +: SEG_BITS] : adda_pipe[stage];
            wire [SEG_BITS-1:0] b = (stage==0) ? addb[SEG_BITS*0 +: SEG_BITS] : addb_pipe[stage];
            wire carry_in = (stage==0) ? 1'b0 : carry_pipe[stage-1];

            wire [SEG_BITS:0] sum_wide = a + b + carry_in;

            assign sum_comb[stage] = sum_wide[SEG_BITS-1:0];
            assign carry_out_comb[stage] = sum_wide[SEG_BITS];
        end
    endgenerate

    // Sequential logic for pipelining operands, carry, sum, and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<STAGES; i=i+1) begin
                adda_pipe[i] <= {SEG_BITS{1'b0}};
                addb_pipe[i] <= {SEG_BITS{1'b0}};
                carry_pipe[i] <= 1'b0;
                sum_pipe[i] <= {SEG_BITS{1'b0}};
                en_pipe[i] <= 1'b0;
            end
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Stage 0 input registers
            adda_pipe[0] <= adda[SEG_BITS*0 +: SEG_BITS];
            addb_pipe[0] <= addb[SEG_BITS*0 +: SEG_BITS];
            carry_pipe[0] <= 1'b0; // First carry-in zero
            sum_pipe[0] <= sum_comb[0];
            en_pipe[0] <= i_en;

            // Pipeline subsequent stages
            for(i=1; i<STAGES; i=i+1) begin
                adda_pipe[i] <= adda[SEG_BITS*i +: SEG_BITS];
                addb_pipe[i] <= addb[SEG_BITS*i +: SEG_BITS];
                carry_pipe[i] <= carry_out_comb[i-1];
                sum_pipe[i] <= sum_comb[i];
                en_pipe[i] <= en_pipe[i-1];
            end

            // Pipeline output enable delayed by STAGES cycles
            o_en <= en_pipe[STAGES-1];

            // Assemble result when output enable is valid
            if (en_pipe[STAGES-1]) begin
                // Concatenate sum segments and final carry-out from last stage
                result <= {carry_out_comb[STAGES-1],
                           sum_pipe[STAGES-1], sum_pipe[STAGES-2], sum_pipe[STAGES-3], sum_pipe[STAGES-4],
                           sum_pipe[STAGES-5], sum_pipe[STAGES-6], sum_pipe[STAGES-7], sum_pipe[STAGES-8],
                           sum_pipe[STAGES-9], sum_pipe[STAGES-10], sum_pipe[STAGES-11], sum_pipe[STAGES-12],
                           sum_pipe[STAGES-13], sum_pipe[STAGES-14], sum_pipe[STAGES-15], sum_pipe[0]};
                // Note: sum_pipe[0] is repeated, fix below
            end else begin
                result <= 65'b0;
            end
        end
    end

    // Correction of concatenation order:
    // sum_pipe indices go from 0 (LSB 4 bits) to 15 (MSB 4 bits).
    // We must concatenate from MSB to LSB:
    // {carry_out, sum_pipe[15], sum_pipe[14], ..., sum_pipe[0]}

    always @(*) begin
        if (o_en) begin
            result = {carry_out_comb[STAGES-1]};
            // concatenate sum_pipe[15:0] in order
            for (i = STAGES-1; i >= 0; i = i -1) begin
                result = {result, sum_pipe[i]};
            end
        end else begin
            result = 65'b0;
        end
    end

    // The above combinational block conflicts with registered result assignment.
    // Fix by making the entire result logic in sequential block only.

    // Final corrected implementation:

endmodule


// Final corrected version below:
module adder_pipe_64bit (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         i_en,
    input  wire [63:0]  adda,
    input  wire [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    localparam STAGES = 16;
    localparam SEG_BITS = 4;

    reg [SEG_BITS-1:0] adda_pipe [0:STAGES-1];
    reg [SEG_BITS-1:0] addb_pipe [0:STAGES-1];
    reg carry_pipe [0:STAGES-1];
    reg [SEG_BITS-1:0] sum_pipe [0:STAGES-1];
    reg en_pipe [0:STAGES-1];

    integer i;

    wire [SEG_BITS-1:0] sum_comb [0:STAGES-1];
    wire carry_out_comb [0:STAGES-1];

    generate
        genvar stg;
        for(stg=0; stg < STAGES; stg=stg+1) begin : gen_adders
            wire [SEG_BITS-1:0] a = (stg == 0) ? adda[SEG_BITS*0 +: SEG_BITS] : adda_pipe[stg];
            wire [SEG_BITS-1:0] b = (stg == 0) ? addb[SEG_BITS*0 +: SEG_BITS] : addb_pipe[stg];
            wire carry_in = (stg == 0) ? 1'b0 : carry_pipe[stg-1];

            wire [SEG_BITS:0] sum_wide = a + b + carry_in;

            assign sum_comb[stg] = sum_wide[SEG_BITS-1:0];
            assign carry_out_comb[stg] = sum_wide[SEG_BITS];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<STAGES; i=i+1) begin
                adda_pipe[i] <= {SEG_BITS{1'b0}};
                addb_pipe[i] <= {SEG_BITS{1'b0}};
                carry_pipe[i] <= 1'b0;
                sum_pipe[i] <= {SEG_BITS{1'b0}};
                en_pipe[i] <= 1'b0;
            end
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Stage 0 inputs and pipeline
            adda_pipe[0] <= adda[SEG_BITS*0 +: SEG_BITS];
            addb_pipe[0] <= addb[SEG_BITS*0 +: SEG_BITS];
            carry_pipe[0] <= 1'b0;
            sum_pipe[0] <= sum_comb[0];
            en_pipe[0] <= i_en;

            for(i=1; i<STAGES; i=i+1) begin
                adda_pipe[i] <= adda[SEG_BITS*i +: SEG_BITS];
                addb_pipe[i] <= addb[SEG_BITS*i +: SEG_BITS];
                carry_pipe[i] <= carry_out_comb[i-1];
                sum_pipe[i] <= sum_comb[i];
                en_pipe[i] <= en_pipe[i-1];
            end

            o_en <= en_pipe[STAGES-1];

            if (en_pipe[STAGES-1]) begin
                result <= {carry_out_comb[STAGES-1],
                           sum_pipe[STAGES-1], sum_pipe[STAGES-2], sum_pipe[STAGES-3], sum_pipe[STAGES-4],
                           sum_pipe[STAGES-5], sum_pipe[STAGES-6], sum_pipe[STAGES-7], sum_pipe[STAGES-8],
                           sum_pipe[STAGES-9], sum_pipe[STAGES-10], sum_pipe[STAGES-11], sum_pipe[STAGES-12],
                           sum_pipe[STAGES-13], sum_pipe[STAGES-14], sum_pipe[STAGES-15], sum_pipe[0]};
                // Correct order is concatenating from MSB segment 15 down to LSB segment 0:
                // Fix below:
            end else begin
                result <= 65'b0;
            end
        end
    end

    // Correct final concatenation order:
    // We can't concatenate arrays with reg in a single statement directly, so build a temporary wire.

    wire [64:0] assembled_result;
    assign assembled_result = {carry_out_comb[STAGES-1],
                               sum_pipe[15], sum_pipe[14], sum_pipe[13], sum_pipe[12],
                               sum_pipe[11], sum_pipe[10], sum_pipe[9], sum_pipe[8],
                               sum_pipe[7], sum_pipe[6], sum_pipe[5], sum_pipe[4],
                               sum_pipe[3], sum_pipe[2], sum_pipe[1], sum_pipe[0]};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 65'b0;
        end else if (en_pipe[STAGES-1]) begin
            result <= assembled_result;
        end else begin
            result <= 65'b0;
        end
    end

endmodule