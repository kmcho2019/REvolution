module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 16
)(
    input                       clk,
    input                       rst_n,
    input                       i_en,
    input  [DATA_WIDTH-1:0]     adda,
    input  [DATA_WIDTH-1:0]     addb,
    output reg [DATA_WIDTH:0]   result,
    output reg                  o_en
);

    localparam NUM_STAGES = DATA_WIDTH / STG_WIDTH;

    // Pipeline registers for operands sliced by stage
    reg [STG_WIDTH-1:0] adda_reg   [0:NUM_STAGES-1];
    reg [STG_WIDTH-1:0] addb_reg   [0:NUM_STAGES-1];

    // Pipeline registers for partial sums and carry flags
    reg [STG_WIDTH-1:0] sum_reg    [0:NUM_STAGES-1];
    reg                 carry_reg  [0:NUM_STAGES]; // carry_reg[0] is initial carry in (zero)

    // Pipeline valid flags for each stage plus input
    reg valid_reg [0:NUM_STAGES];

    integer i;

    // Combinational wires for sum and carry out per stage
    wire [STG_WIDTH:0] sum_carry_wire [0:NUM_STAGES-1];

    // Initial carry in is zero
    assign carry_reg[0] = 1'b0;

    // Compute sum and carry for each stage combinationally
    genvar stage;
    generate
        for (stage = 0; stage < NUM_STAGES; stage = stage + 1) begin : gen_stage
            assign sum_carry_wire[stage] = adda_reg[stage] + addb_reg[stage] + carry_reg[stage];
        end
    endgenerate

    // Operand registers and valid flags shift through pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                adda_reg[i] <= {STG_WIDTH{1'b0}};
                addb_reg[i] <= {STG_WIDTH{1'b0}};
                sum_reg[i] <= {STG_WIDTH{1'b0}};
                carry_reg[i+1] <= 1'b0;
                valid_reg[i] <= 1'b0;
            end
            valid_reg[NUM_STAGES] <= 1'b0;
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Load operands and valid signal at stage 0
            if (i_en) begin
                for (i = 0; i < NUM_STAGES; i = i + 1) begin
                    adda_reg[i] <= adda[i*STG_WIDTH +: STG_WIDTH];
                    addb_reg[i] <= addb[i*STG_WIDTH +: STG_WIDTH];
                end
            end else begin
                // Hold operands if no new input
                for (i = 0; i < NUM_STAGES; i = i + 1) begin
                    adda_reg[i] <= adda_reg[i];
                    addb_reg[i] <= addb_reg[i];
                end
            end

            valid_reg[0] <= i_en;

            // Register sums and propagate carries and valids through pipeline stages
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                if (valid_reg[i]) begin
                    sum_reg[i] <= sum_carry_wire[i][STG_WIDTH-1:0];
                    carry_reg[i+1] <= sum_carry_wire[i][STG_WIDTH];
                end else begin
                    sum_reg[i] <= sum_reg[i];
                    carry_reg[i+1] <= 1'b0;
                end
            end

            // Propagate valid to next stage
            for (i = 1; i <= NUM_STAGES; i = i + 1) begin
                valid_reg[i] <= valid_reg[i-1];
            end

            // When valid at last stage, assemble result
            if (valid_reg[NUM_STAGES]) begin
                result <= {carry_reg[NUM_STAGES], 
                           sum_reg[NUM_STAGES-1], 
                           sum_reg[NUM_STAGES-2], 
                           sum_reg[NUM_STAGES-3], 
                           sum_reg[NUM_STAGES-4]};
                // For generic NUM_STAGES, concatenate dynamically:
                // This is done in a separate always block below.
            end

            o_en <= valid_reg[NUM_STAGES];
        end
    end

    // Dynamic concatenation of sum_reg slices into result (except MSB carry)
    reg [DATA_WIDTH-1:0] sum_concat;
    integer j;
    always @(*) begin
        sum_concat = {DATA_WIDTH{1'b0}};
        for (j = 0; j < NUM_STAGES; j = j + 1) begin
            sum_concat[j*STG_WIDTH +: STG_WIDTH] = sum_reg[j];
        end
    end

    // Update result MSB concatenation synchronously with valid_reg pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            if (valid_reg[NUM_STAGES]) begin
                result <= {carry_reg[NUM_STAGES], sum_concat};
            end
            o_en <= valid_reg[NUM_STAGES];
        end
    end

endmodule