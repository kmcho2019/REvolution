module adder_pipe_64bit (
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  reg [64:0] result,
    output  reg      o_en
);

    // Pipeline configuration: 4 stages, each 16 bits
    localparam STAGES = 4;
    localparam STAGE_WIDTH = 16;

    // Pipeline registers for operands and enable signals
    reg [63:0] adda_pipe [0:STAGES];
    reg [63:0] addb_pipe [0:STAGES];
    reg        i_en_pipe [0:STAGES];

    // Carry pipeline registers, one per stage + initial carry_in
    reg carry_pipe [0:STAGES];

    // Partial sums from combinational adders (wires)
    wire [STAGE_WIDTH-1:0] sum_stage [0:STAGES-1];
    wire carry_stage [0:STAGES-1];

    integer i;

    // Pipeline input operands and enable signals, and propagate carries
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i <= STAGES; i = i + 1) begin
                adda_pipe[i] <= 64'd0;
                addb_pipe[i] <= 64'd0;
                i_en_pipe[i] <= 1'b0;
            end
            for (i = 0; i <= STAGES; i = i + 1) begin
                carry_pipe[i] <= 1'b0;
            end
            result <= 65'd0;
            o_en <= 1'b0;
        end else begin
            // Shift operands and enable signals through the pipeline registers
            adda_pipe[0] <= adda;
            addb_pipe[0] <= addb;
            i_en_pipe[0] <= i_en;

            for (i = 1; i <= STAGES; i = i + 1) begin
                adda_pipe[i] <= adda_pipe[i-1];
                addb_pipe[i] <= addb_pipe[i-1];
                i_en_pipe[i] <= i_en_pipe[i-1];
            end

            // Initialize carry_in for stage 0
            carry_pipe[0] <= 1'b0;

            // Register carry outs computed combinationally below
            for (i = 1; i <= STAGES; i = i + 1) begin
                carry_pipe[i] <= carry_stage[i-1];
            end

            // Register the final output result and o_en at the last stage
            result <= {carry_stage[STAGES-1],
                       sum_stage[STAGES-1],
                       sum_stage[STAGES-2],
                       sum_stage[STAGES-3],
                       sum_stage[STAGES-4]};
            o_en <= i_en_pipe[STAGES];
        end
    end

    // Combinational adders per stage
    // Each stage adds 16 bits plus carry_in
    generate
        genvar stage_idx;
        for (stage_idx = 0; stage_idx < STAGES; stage_idx = stage_idx + 1) begin : ADDER_STAGES
            wire [STAGE_WIDTH-1:0] a_part = adda_pipe[stage_idx][(stage_idx+1)*STAGE_WIDTH-1 -: STAGE_WIDTH];
            wire [STAGE_WIDTH-1:0] b_part = addb_pipe[stage_idx][(stage_idx+1)*STAGE_WIDTH-1 -: STAGE_WIDTH];
            wire carry_in = carry_pipe[stage_idx];

            assign {carry_stage[stage_idx], sum_stage[stage_idx]} = a_part + b_part + carry_in;
        end
    endgenerate

endmodule