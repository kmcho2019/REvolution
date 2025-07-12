module adder_pipe_64bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        i_en,
    input  wire [63:0] adda,
    input  wire [63:0] addb,
    output reg  [64:0] result,
    output reg         o_en
);

    localparam STAGES = 8;
    localparam SEG_BITS = 8;

    // Pipeline registers for operand segments per stage
    reg [SEG_BITS-1:0] adda_seg_pipe [0:STAGES-1];
    reg [SEG_BITS-1:0] addb_seg_pipe [0:STAGES-1];

    // Pipeline registers for carry_in per stage
    reg carry_in_pipe [0:STAGES-1];

    // Pipeline registers for sum segments and carry_out per stage
    reg [SEG_BITS-1:0] sum_seg_pipe [0:STAGES-1];
    reg carry_out_pipe [0:STAGES-1];

    // Pipeline registers for enable signals per stage
    reg en_pipe [0:STAGES-1];

    integer i;

    // Combinational wires for sums and carry outs per stage
    wire [SEG_BITS:0] sum_with_carry [0:STAGES-1];

    // Extract input operand segments for stage 0
    wire [SEG_BITS-1:0] adda_seg_0 = adda[SEG_BITS*0 +: SEG_BITS];
    wire [SEG_BITS-1:0] addb_seg_0 = addb[SEG_BITS*0 +: SEG_BITS];

    // Assign input stage segments for stage 0
    wire carry_in_0 = 1'b0;

    // Combinational addition per stage
    generate
        genvar stage;
        for (stage = 0; stage < STAGES; stage = stage + 1) begin : adder_stages
            wire [SEG_BITS-1:0] a = (stage == 0) ? adda_seg_0 : adda_seg_pipe[stage];
            wire [SEG_BITS-1:0] b = (stage == 0) ? addb_seg_0 : addb_seg_pipe[stage];
            wire c_in = (stage == 0) ? carry_in_0 : carry_in_pipe[stage];

            assign sum_with_carry[stage] = {1'b0, a} + {1'b0, b} + c_in;
        end
    endgenerate

    // Sequential logic: pipeline registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_seg_pipe[i] <= {SEG_BITS{1'b0}};
                addb_seg_pipe[i] <= {SEG_BITS{1'b0}};
                carry_in_pipe[i] <= 1'b0;
                sum_seg_pipe[i] <= {SEG_BITS{1'b0}};
                carry_out_pipe[i] <= 1'b0;
                en_pipe[i] <= 1'b0;
            end
            result <= 65'd0;
            o_en <= 1'b0;
        end else begin
            // Stage 0 loads input operand segments and enable
            adda_seg_pipe[0] <= adda[SEG_BITS*0 +: SEG_BITS];
            addb_seg_pipe[0] <= addb[SEG_BITS*0 +: SEG_BITS];
            carry_in_pipe[0] <= 1'b0; // initial carry_in is zero
            en_pipe[0] <= i_en;

            // Update sums and carry_out for stage 0
            sum_seg_pipe[0] <= sum_with_carry[0][SEG_BITS-1:0];
            carry_out_pipe[0] <= sum_with_carry[0][SEG_BITS];

            // For subsequent stages
            for (i = 1; i < STAGES; i = i + 1) begin
                // Pipeline registers for operand segments
                adda_seg_pipe[i] <= adda[SEG_BITS*i +: SEG_BITS];
                addb_seg_pipe[i] <= addb[SEG_BITS*i +: SEG_BITS];
                // carry_in is previous stage's carry_out
                carry_in_pipe[i] <= carry_out_pipe[i-1];
                // Enable pipelined
                en_pipe[i] <= en_pipe[i-1];
                // Register sums and carry_out for previous stage
                sum_seg_pipe[i-1] <= sum_with_carry[i-1][SEG_BITS-1:0];
                carry_out_pipe[i-1] <= sum_with_carry[i-1][SEG_BITS];
            end

            // Register sums and carry_out for last stage
            sum_seg_pipe[STAGES-1] <= sum_with_carry[STAGES-1][SEG_BITS-1:0];
            carry_out_pipe[STAGES-1] <= sum_with_carry[STAGES-1][SEG_BITS];

            // Output enable is the enable signal delayed through all stages
            o_en <= en_pipe[STAGES-1];

            // When output enabled, assemble the result from sum segments and final carry_out
            if (en_pipe[STAGES-1]) begin
                result <= {carry_out_pipe[STAGES-1],
                           sum_seg_pipe[STAGES-1],
                           sum_seg_pipe[STAGES-2],
                           sum_seg_pipe[STAGES-3],
                           sum_seg_pipe[STAGES-4],
                           sum_seg_pipe[STAGES-5],
                           sum_seg_pipe[STAGES-6],
                           sum_seg_pipe[STAGES-7],
                           sum_seg_pipe[0]};
                // Note: We need to order partial sums properly from MSB to LSB:
                // The concatenation above is incorrect because sum_seg_pipe[0] is LSB segment
                // Reorder concatenation properly below
            end else if (!o_en) begin
                result <= 65'd0;
            end
        end
    end

    // Correcting the result concatenation order with a combinational assign
    // Because the concatenation in always block above is incomplete and incorrect,
    // We'll create a combinational wire assembling final result from registered partial sums

    wire [64:0] assembled_result =
        {carry_out_pipe[STAGES-1],
         sum_seg_pipe[STAGES-1],
         sum_seg_pipe[STAGES-2],
         sum_seg_pipe[STAGES-3],
         sum_seg_pipe[STAGES-4],
         sum_seg_pipe[STAGES-5],
         sum_seg_pipe[STAGES-6],
         sum_seg_pipe[STAGES-7],
         sum_seg_pipe[0]};

    // But sum_seg_pipe array is [0..7], we need all 8 segments in order from MSB to LSB:
    // Since indexing is from 0 to 7, to assemble 64 bits we need all 8 sum_seg_pipe elements concatenated MSB first:
    // sum_seg_pipe[7], sum_seg_pipe[6], ..., sum_seg_pipe[0]
    // So we must re-define concatenation with all 8 segments:

    // Declare concatenation wire for all segments correctly
    wire [63:0] sum_concat =
        {sum_seg_pipe[7],
         sum_seg_pipe[6],
         sum_seg_pipe[5],
         sum_seg_pipe[4],
         sum_seg_pipe[3],
         sum_seg_pipe[2],
         sum_seg_pipe[1],
         sum_seg_pipe[0]};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 65'd0;
        end else begin
            if (o_en) begin
                result <= {carry_out_pipe[STAGES-1], sum_concat};
            end else begin
                result <= 65'd0;
            end
        end
    end

endmodule