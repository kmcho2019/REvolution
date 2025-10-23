module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STAGE_WIDTH = 16,
    parameter STAGES = DATA_WIDTH / STAGE_WIDTH  // 4 stages for 64 bits / 16 bits
)(
    input                          clk,
    input                          rst_n,
    input                          i_en,
    input      [DATA_WIDTH-1:0]    adda,
    input      [DATA_WIDTH-1:0]    addb,
    output reg [DATA_WIDTH:0]      result,  // 65 bits result
    output reg                     o_en
);

    // Pipeline registers for operands and enable signals
    reg [DATA_WIDTH-1:0] adda_pipe   [0:STAGES];
    reg [DATA_WIDTH-1:0] addb_pipe   [0:STAGES];
    reg                  i_en_pipe   [0:STAGES];

    // Carry registers between stages (STAGES+1 elements: stage0 carry-in=0)
    reg                  carry_pipe  [0:STAGES];

    // Sum outputs registers for each stage
    reg [STAGE_WIDTH-1:0] sum_pipe   [0:STAGES-1];

    // Combinational wires for each stage sum and carry
    wire [STAGE_WIDTH-1:0] sum_wire   [0:STAGES-1];
    wire                  carry_wire [0:STAGES-1];

    integer i;

    // Assign zero to initial carry_in
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            carry_pipe[0] <= 1'b0;
        else
            carry_pipe[0] <= 1'b0; // always zero carry-in to stage 0
    end

    // Generate combinational addition logic for each pipeline stage
    genvar stage;
    generate
        for(stage = 0; stage < STAGES; stage = stage + 1) begin : PIPELINE_STAGES
            // Slice operands for this stage from the pipeline registers at stage index
            wire [STAGE_WIDTH-1:0] a_stage = adda_pipe[stage][(stage+1)*STAGE_WIDTH-1 -: STAGE_WIDTH];
            wire [STAGE_WIDTH-1:0] b_stage = addb_pipe[stage][(stage+1)*STAGE_WIDTH-1 -: STAGE_WIDTH];
            wire carry_in = carry_pipe[stage];

            // Perform addition with carry-in
            assign {carry_wire[stage], sum_wire[stage]} = a_stage + b_stage + carry_in;
        end
    endgenerate

    // Sequential pipeline registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialize all pipeline registers
            for (i = 0; i <= STAGES; i = i + 1) begin
                adda_pipe[i] <= {DATA_WIDTH{1'b0}};
                addb_pipe[i] <= {DATA_WIDTH{1'b0}};
                i_en_pipe[i] <= 1'b0;
                carry_pipe[i] <= 1'b0;
            end
            for (i = 0; i < STAGES; i = i +1)
                sum_pipe[i] <= {STAGE_WIDTH{1'b0}};

            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Stage 0 input registers
            adda_pipe[0] <= adda;
            addb_pipe[0] <= addb;
            i_en_pipe[0] <= i_en;
            carry_pipe[0] <= 1'b0; // carry-in zero for first stage

            // Update pipeline registers for stages 1 to STAGES
            for (i = 1; i <= STAGES; i = i + 1) begin
                adda_pipe[i] <= adda_pipe[i-1];
                addb_pipe[i] <= addb_pipe[i-1];
                i_en_pipe[i] <= i_en_pipe[i-1];
            end

            // Register sums and carry-outs for stages 0 to STAGES-1
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= sum_wire[i];
                carry_pipe[i+1] <= carry_wire[i];
            end

            // Assemble the result from the registered sums and last carry-out
            // Concatenate sums from MSB to LSB: stage3..stage0, plus final carry at MSB
            result <= {
                carry_pipe[STAGES],
                sum_pipe[STAGES-1],
                sum_pipe[STAGES-2],
                sum_pipe[STAGES-3],
                sum_pipe[0]
            };

            // Output enable delayed by STAGES cycles
            o_en <= i_en_pipe[STAGES];
        end
    end

endmodule