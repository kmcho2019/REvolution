module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input       [63:0]  adda,
    input       [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);
    // Parameters
    localparam STG_WIDTH = 8;
    localparam STAGES = 64 / STG_WIDTH; // 8 stages

    // Pipeline registers for sum parts and carry
    reg [STG_WIDTH-1:0] sum_pipe [0:STAGES-1];
    reg carry_pipe [0:STAGES]; // carry_pipe[0] is carry in to stage 0 (always 0)
    reg en_pipe [0:STAGES];

    // Internal wires for operands slices and add results per stage
    wire [STG_WIDTH-1:0] adda_slices [0:STAGES-1];
    wire [STG_WIDTH-1:0] addb_slices [0:STAGES-1];
    wire [STG_WIDTH:0] add_res [0:STAGES-1]; // includes carry out as MSB

    genvar i;

    // Generate operand slices
    generate
        for (i = 0; i < STAGES; i = i + 1) begin : operand_slices_gen
            assign adda_slices[i] = adda[i*STG_WIDTH +: STG_WIDTH];
            assign addb_slices[i] = addb[i*STG_WIDTH +: STG_WIDTH];
        end
    endgenerate

    // Combinational adders per stage
    generate
        for (i = 0; i < STAGES; i = i + 1) begin : adder_stages
            assign add_res[i] = {1'b0, adda_slices[i]} + {1'b0, addb_slices[i]} + carry_pipe[i];
        end
    endgenerate

    // Combinational concatenation of sum parts and final carry
    wire [64:0] sum_concat;
    generate
        for (i = 0; i < STAGES; i = i + 1) begin : concat_sum_gen
            assign sum_concat[i*STG_WIDTH +: STG_WIDTH] = sum_pipe[i];
        end
    endgenerate
    assign sum_concat[64] = carry_pipe[STAGES];

    integer j;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < STAGES; j = j + 1) begin
                sum_pipe[j] <= {STG_WIDTH{1'b0}};
                carry_pipe[j] <= 1'b0;
                en_pipe[j] <= 1'b0;
            end
            carry_pipe[STAGES] <= 1'b0;
            en_pipe[STAGES] <= 1'b0;
            result <= {65{1'b0}};
            o_en <= 1'b0;
        end else begin
            // Initial carry-in zero
            carry_pipe[0] <= 1'b0;
            en_pipe[0] <= i_en;

            // Update pipeline registers for sum, carry, and enable
            for (j = 0; j < STAGES; j = j + 1) begin
                sum_pipe[j] <= add_res[j][STG_WIDTH-1:0];       // lower bits are sum
                carry_pipe[j+1] <= add_res[j][STG_WIDTH];       // carry out to next stage
                en_pipe[j+1] <= en_pipe[j];                      // propagate enable
            end

            // Register final result and output enable when data is valid
            result <= sum_concat;
            o_en <= en_pipe[STAGES];
        end
    end
endmodule