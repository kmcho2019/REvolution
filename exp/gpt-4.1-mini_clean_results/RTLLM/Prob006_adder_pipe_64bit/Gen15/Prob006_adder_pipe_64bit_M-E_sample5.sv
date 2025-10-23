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
    localparam SEG_WIDTH = 4;

    // Pipeline registers for operand slices per stage
    reg [SEG_WIDTH-1:0] adda_pipe [0:STAGES-1];
    reg [SEG_WIDTH-1:0] addb_pipe [0:STAGES-1];

    // Carry in per stage pipeline register
    reg carry_in_pipe [0:STAGES-1];

    // Sum slices per stage pipeline register
    reg [SEG_WIDTH-1:0] sum_pipe [0:STAGES-1];

    // Carry out per stage pipeline register
    reg carry_out_pipe [0:STAGES-1];

    // Enable signal pipeline registers per stage
    reg en_pipe [0:STAGES-1];

    integer i;

    // Combinational wires for sums and carry outs per stage
    wire [SEG_WIDTH:0] sum_with_carry [0:STAGES-1];

    // Combinational addition per stage
    generate
        genvar stage;
        for (stage = 0; stage < STAGES; stage = stage + 1) begin : ADD_STAGE
            // For stage 0, inputs come directly from adda/addb and carry_in=0
            wire [SEG_WIDTH-1:0] a = (stage == 0) ? adda[SEG_WIDTH*0 +: SEG_WIDTH] : adda_pipe[stage];
            wire [SEG_WIDTH-1:0] b = (stage == 0) ? addb[SEG_WIDTH*0 +: SEG_WIDTH] : addb_pipe[stage];
            wire c_in = (stage == 0) ? 1'b0 : carry_in_pipe[stage];
            assign sum_with_carry[stage] = {1'b0, a} + {1'b0, b} + c_in;
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and outputs
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= {SEG_WIDTH{1'b0}};
                addb_pipe[i] <= {SEG_WIDTH{1'b0}};
                carry_in_pipe[i] <= 1'b0;
                sum_pipe[i] <= {SEG_WIDTH{1'b0}};
                carry_out_pipe[i] <= 1'b0;
                en_pipe[i] <= 1'b0;
            end
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Stage 0 input registers: load input slices and enable
            adda_pipe[0] <= adda[SEG_WIDTH*0 +: SEG_WIDTH];
            addb_pipe[0] <= addb[SEG_WIDTH*0 +: SEG_WIDTH];
            carry_in_pipe[0] <= 1'b0; // carry_in for stage 0 is always zero
            en_pipe[0] <= i_en;

            // Register sum and carry_out for stage 0 from combinational logic
            sum_pipe[0] <= sum_with_carry[0][SEG_WIDTH-1:0];
            carry_out_pipe[0] <= sum_with_carry[0][SEG_WIDTH];

            // Subsequent stages pipeline registers update
            for (i = 1; i < STAGES; i = i + 1) begin
                // Load operands slices from inputs
                adda_pipe[i] <= adda[SEG_WIDTH*i +: SEG_WIDTH];
                addb_pipe[i] <= addb[SEG_WIDTH*i +: SEG_WIDTH];
                // Carry_in from previous stage's carry_out registered previous cycle
                carry_in_pipe[i] <= carry_out_pipe[i-1];
                // Enable pipelining
                en_pipe[i] <= en_pipe[i-1];
                // Sum and carry_out registered from combinational addition of previous stage
                sum_pipe[i-1] <= sum_with_carry[i-1][SEG_WIDTH-1:0];
                carry_out_pipe[i-1] <= sum_with_carry[i-1][SEG_WIDTH];
            end

            // Register sum and carry_out of last stage combinational adder
            sum_pipe[STAGES-1] <= sum_with_carry[STAGES-1][SEG_WIDTH-1:0];
            carry_out_pipe[STAGES-1] <= sum_with_carry[STAGES-1][SEG_WIDTH];

            // Output enable delayed through pipeline
            o_en <= en_pipe[STAGES-1];

            // When output is enabled, assemble final 65-bit result: carry_out + all sum slices (MSB first)
            if (en_pipe[STAGES-1]) begin
                // Concatenate sum slices in order from MSB stage (15) down to LSB stage (0)
                result <= {carry_out_pipe[STAGES-1],
                           sum_pipe[STAGES-1],
                           sum_pipe[STAGES-2],
                           sum_pipe[STAGES-3],
                           sum_pipe[STAGES-4],
                           sum_pipe[STAGES-5],
                           sum_pipe[STAGES-6],
                           sum_pipe[STAGES-7],
                           sum_pipe[STAGES-8],
                           sum_pipe[STAGES-9],
                           sum_pipe[STAGES-10],
                           sum_pipe[STAGES-11],
                           sum_pipe[STAGES-12],
                           sum_pipe[STAGES-13],
                           sum_pipe[STAGES-14],
                           sum_pipe[STAGES-15]};
            end else begin
                result <= 65'b0;
            end
        end
    end

endmodule