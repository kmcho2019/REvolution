module adder_pipe_64bit #(
    parameter WIDTH = 64,
    parameter STG_WIDTH = 8,
    parameter STAGES = WIDTH / STG_WIDTH
)(
    input                   clk,
    input                   rst_n,
    input                   i_en,
    input       [WIDTH-1:0] adda,
    input       [WIDTH-1:0] addb,
    output reg  [WIDTH:0]   result,
    output reg              o_en
);

    // Pipeline registers for operand slices
    reg [STG_WIDTH-1:0] adda_pipe [0:STAGES-1];
    reg [STG_WIDTH-1:0] addb_pipe [0:STAGES-1];

    // Carry and enable pipeline registers
    reg carry_pipe [0:STAGES];
    reg en_pipe    [0:STAGES];

    // Partial sums stored in registers per stage
    reg [STG_WIDTH-1:0] sum_pipe [0:STAGES-1];

    // Combinational sums + carry-out wires per stage
    wire [STG_WIDTH:0] add_res [0:STAGES-1];

    genvar i;
    generate
        for (i = 0; i < STAGES; i = i + 1) begin : ADD_STAGE_GEN
            assign add_res[i] = {1'b0, adda_pipe[i]} + {1'b0, addb_pipe[i]} + carry_pipe[i];
        end
    endgenerate

    integer j;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            for (j = 0; j < STAGES; j = j + 1) begin
                adda_pipe[j] <= {STG_WIDTH{1'b0}};
                addb_pipe[j] <= {STG_WIDTH{1'b0}};
                sum_pipe[j]  <= {STG_WIDTH{1'b0}};
                carry_pipe[j] <= 1'b0;
                en_pipe[j] <= 1'b0;
            end
            carry_pipe[STAGES] <= 1'b0;
            en_pipe[STAGES] <= 1'b0;
            result <= {(WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Stage 0: load lowest STG_WIDTH bits and carry_in = 0
            adda_pipe[0] <= adda[STG_WIDTH-1:0];
            addb_pipe[0] <= addb[STG_WIDTH-1:0];
            carry_pipe[0] <= 1'b0;
            en_pipe[0] <= i_en;

            // Propagate operand slices, carry_in, and enable through stages 1..STAGES-1
            for (j = 1; j < STAGES; j = j + 1) begin
                adda_pipe[j] <= adda[j*STG_WIDTH +: STG_WIDTH];
                addb_pipe[j] <= addb[j*STG_WIDTH +: STG_WIDTH];
                carry_pipe[j] <= add_res[j-1][STG_WIDTH]; // carry_out from previous stage
                en_pipe[j] <= en_pipe[j-1];
            end

            // Register partial sums from combinational adders
            for (j = 0; j < STAGES; j = j + 1) begin
                sum_pipe[j] <= add_res[j][STG_WIDTH-1:0];
            end

            // Register final carry_out and propagate enable for output stage
            carry_pipe[STAGES] <= add_res[STAGES-1][STG_WIDTH];
            en_pipe[STAGES] <= en_pipe[STAGES-1];

            // Assemble the final 65-bit result by concatenating partial sums and carry out
            // Concatenate in order: sum_pipe[0] is lowest bits, sum_pipe[STAGES-1] highest bits
            // Use a temporary variable to avoid combinational logic in sequential block
            reg [WIDTH:0] concat_result;
            concat_result = carry_pipe[STAGES];
            for (j = STAGES-1; j >= 0; j = j - 1) begin
                concat_result = (concat_result << STG_WIDTH) | sum_pipe[j];
            end

            result <= concat_result;
            o_en <= en_pipe[STAGES];
        end
    end

endmodule