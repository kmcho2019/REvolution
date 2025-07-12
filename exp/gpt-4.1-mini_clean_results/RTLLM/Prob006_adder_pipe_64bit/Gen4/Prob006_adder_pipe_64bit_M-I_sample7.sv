module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 8
)(
    input                   clk,
    input                   rst_n,
    input                   i_en,
    input      [DATA_WIDTH-1:0] adda,
    input      [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0]   result,
    output reg              o_en
);

    localparam STAGES = DATA_WIDTH / STG_WIDTH; // 64/8 = 8 stages

    // Pipeline registers for operand slices per stage
    reg [STG_WIDTH-1:0] adda_pipe [0:STAGES-1];
    reg [STG_WIDTH-1:0] addb_pipe [0:STAGES-1];

    // Carry pipeline registers (carry-in for each stage and the final carry-out)
    reg carry_pipe [0:STAGES];

    // Partial sum pipeline registers
    reg [STG_WIDTH-1:0] sum_pipe [0:STAGES-1];

    // Pipeline enable signals for input enable propagation
    reg i_en_pipe [0:STAGES];

    integer i;

    // Combinational addition result wires per stage (STG_WIDTH+1 bits for carry)
    wire [STG_WIDTH:0] add_stage_res [0:STAGES-1];

    // Generate combinational adders for each pipeline stage
    generate
        genvar idx;
        for (idx = 0; idx < STAGES; idx = idx + 1) begin : adder_stage
            assign add_stage_res[idx] = {1'b0, adda_pipe[idx]} + {1'b0, addb_pipe[idx]} + carry_pipe[idx];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= {STG_WIDTH{1'b0}};
                addb_pipe[i] <= {STG_WIDTH{1'b0}};
                sum_pipe[i]  <= {STG_WIDTH{1'b0}};
                carry_pipe[i] <= 1'b0;
                i_en_pipe[i] <= 1'b0;
            end
            carry_pipe[STAGES] <= 1'b0;
            i_en_pipe[STAGES] <= 1'b0;
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Stage 0: register least significant slices and initial carry in = 0
            adda_pipe[0] <= adda[STG_WIDTH-1:0];
            addb_pipe[0] <= addb[STG_WIDTH-1:0];
            carry_pipe[0] <= 1'b0;
            i_en_pipe[0] <= i_en;

            // Subsequent stages register operand slices and carry-in from previous stage's carry-out
            for (i = 1; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= adda[i*STG_WIDTH +: STG_WIDTH];
                addb_pipe[i] <= addb[i*STG_WIDTH +: STG_WIDTH];
                carry_pipe[i] <= add_stage_res[i-1][STG_WIDTH];
                i_en_pipe[i] <= i_en_pipe[i-1];
            end

            // Register partial sums from combinational adders
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= add_stage_res[i][STG_WIDTH-1:0];
            end

            // Register last carry out
            carry_pipe[STAGES] <= add_stage_res[STAGES-1][STG_WIDTH];

            // Propagate enable signal through pipeline
            i_en_pipe[STAGES] <= i_en_pipe[STAGES-1];

            // Assemble 65-bit result from partial sums and carry_out
            result <= {carry_pipe[STAGES],
                       sum_pipe[STAGES-1],
                       sum_pipe[STAGES-2],
                       sum_pipe[STAGES-3],
                       sum_pipe[STAGES-4],
                       sum_pipe[STAGES-5],
                       sum_pipe[STAGES-6],
                       sum_pipe[STAGES-7],
                       sum_pipe[0]};

            // Output enable indicates valid result after pipeline latency
            o_en <= i_en_pipe[STAGES];
        end
    end

endmodule