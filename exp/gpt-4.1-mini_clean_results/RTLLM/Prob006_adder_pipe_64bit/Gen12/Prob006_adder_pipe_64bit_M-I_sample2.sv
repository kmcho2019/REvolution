module adder_pipe_64bit #(
    parameter STG_WIDTH = 8,
    parameter STAGES = 64 / STG_WIDTH
)(
    input                   clk,
    input                   rst_n,
    input                   i_en,
    input   [STG_WIDTH*STAGES-1:0] adda,
    input   [STG_WIDTH*STAGES-1:0] addb,
    output reg [STG_WIDTH*STAGES:0] result,  // 65-bit result
    output reg              o_en
);

    // Pipeline registers for operand slices
    reg [STG_WIDTH-1:0] adda_pipe [0:STAGES-1];
    reg [STG_WIDTH-1:0] addb_pipe [0:STAGES-1];
    reg                 carry_pipe [0:STAGES];
    reg                 en_pipe [0:STAGES];

    // Combinational sums including carry-out for each stage
    wire [STG_WIDTH:0] sum_stage [0:STAGES-1];

    integer i;

    // Generate combinational adders for each stage
    generate
        genvar stage;
        for (stage = 0; stage < STAGES; stage = stage + 1) begin : gen_adders
            assign sum_stage[stage] = adda_pipe[stage] + addb_pipe[stage] + carry_pipe[stage];
        end
    endgenerate

    // Combinational logic to assemble sum slices into a wide vector
    reg [STG_WIDTH*STAGES-1:0] sum_concat;
    always @(*) begin
        for (i = 0; i < STAGES; i = i + 1) begin
            sum_concat[i*STG_WIDTH +: STG_WIDTH] = sum_stage[i][STG_WIDTH-1:0];
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and outputs
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= {STG_WIDTH{1'b0}};
                addb_pipe[i] <= {STG_WIDTH{1'b0}};
                carry_pipe[i] <= 1'b0;
                en_pipe[i] <= 1'b0;
            end
            carry_pipe[STAGES] <= 1'b0;
            en_pipe[STAGES] <= 1'b0;
            result <= {(STG_WIDTH*STAGES+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Stage 0: load operands and initial carry_in=0, enable
            adda_pipe[0] <= adda[STG_WIDTH-1:0];
            addb_pipe[0] <= addb[STG_WIDTH-1:0];
            carry_pipe[0] <= 1'b0;
            en_pipe[0] <= i_en;

            // Subsequent stages: load operand slices, propagate carry-out and enable
            for (i = 1; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= adda[i*STG_WIDTH +: STG_WIDTH];
                addb_pipe[i] <= addb[i*STG_WIDTH +: STG_WIDTH];
                carry_pipe[i] <= sum_stage[i-1][STG_WIDTH]; // carry out from previous stage
                en_pipe[i] <= en_pipe[i-1];
            end

            // Final carry-out and enable propagation
            carry_pipe[STAGES] <= sum_stage[STAGES-1][STG_WIDTH];
            en_pipe[STAGES] <= en_pipe[STAGES-1];

            // Assemble final result: sum slices + final carry out
            result <= {carry_pipe[STAGES], sum_concat};
            o_en <= en_pipe[STAGES];
        end
    end

endmodule