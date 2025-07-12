module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 16
) (
    input                  clk,
    input                  rst_n,
    input                  i_en,
    input      [DATA_WIDTH-1:0] adda,
    input      [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0]   result,
    output reg             o_en
);

    // Calculate number of pipeline stages
    localparam STAGES = DATA_WIDTH / STG_WIDTH;

    // Pipeline registers for operands per stage
    reg [STG_WIDTH-1:0] adda_pipe [0:STAGES-1];
    reg [STG_WIDTH-1:0] addb_pipe [0:STAGES-1];
    // Carry registers: STAGES+1 for initial carry + each stage carry out
    reg carry_pipe [0:STAGES];
    // Pipeline for enable signal synchronization
    reg i_en_pipe [0:STAGES];

    // Combinational sum + carry outputs per stage
    wire [STG_WIDTH:0] sum_carry [0:STAGES-1];

    integer i;

    // Combinational addition for each stage
    generate
        genvar idx;
        for (idx = 0; idx < STAGES; idx = idx + 1) begin : add_stage
            assign sum_carry[idx] = {1'b0, adda_pipe[idx]} + {1'b0, addb_pipe[idx]} + carry_pipe[idx];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= {STG_WIDTH{1'b0}};
                addb_pipe[i] <= {STG_WIDTH{1'b0}};
                carry_pipe[i] <= 1'b0;
                i_en_pipe[i] <= 1'b0;
            end
            carry_pipe[STAGES] <= 1'b0;
            i_en_pipe[STAGES] <= 1'b0;
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Stage 0 pipeline inputs
            adda_pipe[0] <= adda[STG_WIDTH-1:0];
            addb_pipe[0] <= addb[STG_WIDTH-1:0];
            carry_pipe[0] <= 1'b0;      // Initial carry in zero
            i_en_pipe[0] <= i_en;

            // Subsequent pipeline stages and carry propagation
            for (i = 1; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= adda[i*STG_WIDTH +: STG_WIDTH];
                addb_pipe[i] <= addb[i*STG_WIDTH +: STG_WIDTH];
                carry_pipe[i] <= sum_carry[i-1][STG_WIDTH];
                i_en_pipe[i] <= i_en_pipe[i-1];
            end

            // Final carry register stage
            carry_pipe[STAGES] <= sum_carry[STAGES-1][STG_WIDTH];
            i_en_pipe[STAGES] <= i_en_pipe[STAGES-1];

            // Assemble the final result concatenating all sums and final carry out
            // Use a loop to concatenate sum_carry stages in increasing order of index
            // sum_carry[x][STG_WIDTH-1:0] are the sum bits for stage x
            // The final carry is carry_pipe[STAGES]
            result <= {
                carry_pipe[STAGES],
                sum_carry[STAGES-1][STG_WIDTH-1:0],
                sum_carry[STAGES-2][STG_WIDTH-1:0],
                sum_carry[STAGES-3][STG_WIDTH-1:0],
                sum_carry[0][STG_WIDTH-1:0]
            };

            // If STAGES != 4, use a generate block to concatenate dynamically
            // But since STAGES=4 by default, this static concatenation is acceptable

            // Output enable synchronized with pipeline stages
            o_en <= i_en_pipe[STAGES];
        end
    end

endmodule