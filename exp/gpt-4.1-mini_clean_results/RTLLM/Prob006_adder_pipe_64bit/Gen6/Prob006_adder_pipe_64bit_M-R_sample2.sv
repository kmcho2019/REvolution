module adder_pipe_64bit #(
    parameter DATA_WIDTH  = 64,
    parameter STAGE_WIDTH = 16,
    parameter NUM_STAGES  = DATA_WIDTH / STAGE_WIDTH
) (
    input  wire                     clk,
    input  wire                     rst_n,
    input  wire                     i_en,
    input  wire [DATA_WIDTH-1:0]   adda,
    input  wire [DATA_WIDTH-1:0]   addb,
    output reg  [DATA_WIDTH:0]     result,
    output reg                     o_en
);

    // Internal pipeline registers for operands and carry-in per stage
    reg [STAGE_WIDTH-1:0] adda_reg [0:NUM_STAGES-1];
    reg [STAGE_WIDTH-1:0] addb_reg [0:NUM_STAGES-1];
    reg                   carry_in_reg [0:NUM_STAGES-1];

    // Pipeline enable shift register
    reg [NUM_STAGES:0] en_pipe;

    // Wires for combinational sum and carry-out per stage
    wire [STAGE_WIDTH-1:0] sum_wire [0:NUM_STAGES-1];
    wire carry_out_wire [0:NUM_STAGES-1];

    integer i;

    // Combinational adders per stage
    // sum_wire[i], carry_out_wire[i] computed from registered operands and carry_in
    generate
        genvar gi;
        for (gi = 0; gi < NUM_STAGES; gi = gi + 1) begin : ADD_STAGE
            assign {carry_out_wire[gi], sum_wire[gi]} = adda_reg[gi] + addb_reg[gi] + carry_in_reg[gi];
        end
    endgenerate

    // Registers update: shift operands and carries through pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and outputs
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                adda_reg[i]     <= {STAGE_WIDTH{1'b0}};
                addb_reg[i]     <= {STAGE_WIDTH{1'b0}};
                carry_in_reg[i] <= 1'b0;
            end
            en_pipe <= { (NUM_STAGES+1){1'b0} };
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en   <= 1'b0;
        end else begin
            // Shift enable pipeline
            en_pipe <= {en_pipe[NUM_STAGES-1:0], i_en};

            // Stage 0: Load operands and initial carry_in=0 if input enable asserted
            if (i_en) begin
                adda_reg[0]     <= adda[STAGE_WIDTH*0 +: STAGE_WIDTH];
                addb_reg[0]     <= addb[STAGE_WIDTH*0 +: STAGE_WIDTH];
                carry_in_reg[0] <= 1'b0;
            end else begin
                // Keep values if no new input
                adda_reg[0]     <= adda_reg[0];
                addb_reg[0]     <= addb_reg[0];
                carry_in_reg[0] <= carry_in_reg[0];
            end

            // Pipeline carry_in and operands for stages 1 .. NUM_STAGES-1
            for (i = 1; i < NUM_STAGES; i = i + 1) begin
                adda_reg[i]     <= adda[STAGE_WIDTH*i +: STAGE_WIDTH];
                addb_reg[i]     <= addb[STAGE_WIDTH*i +: STAGE_WIDTH];
                carry_in_reg[i] <= carry_out_wire[i-1];
            end

            // Output registers update at pipeline exit stage
            if (en_pipe[NUM_STAGES]) begin
                // Assemble full 65-bit result from sum wires and final carry-out
                result <= {carry_out_wire[NUM_STAGES-1], 
                           sum_wire[NUM_STAGES-1],
                           sum_wire[NUM_STAGES-2],
                           sum_wire[NUM_STAGES-3],
                           sum_wire[NUM_STAGES-4]};
                // Above is hardcoded for NUM_STAGES=4; below is generic version for any NUM_STAGES:
                /*
                reg [DATA_WIDTH-1:0] assembled_sum;
                integer j;
                assembled_sum = {DATA_WIDTH{1'b0}};
                for (j = 0; j < NUM_STAGES; j = j + 1) begin
                    assembled_sum[STAGE_WIDTH*j +: STAGE_WIDTH] = sum_wire[j];
                end
                result <= {carry_out_wire[NUM_STAGES-1], assembled_sum};
                */
            end

            // Output enable updated from pipeline enable register
            o_en <= en_pipe[NUM_STAGES];
        end
    end

    // To implement generic assembly of sum for any NUM_STAGES,
    // use a combinational block with a temporary register
    reg [DATA_WIDTH-1:0] assembled_sum;
    always @(*) begin
        assembled_sum = {DATA_WIDTH{1'b0}};
        for (i = 0; i < NUM_STAGES; i = i + 1) begin
            assembled_sum[STAGE_WIDTH*i +: STAGE_WIDTH] = sum_wire[i];
        end
    end

    // Replace hardcoded result update with generic assignment at pipeline output stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= {(DATA_WIDTH+1){1'b0}};
        end else if (en_pipe[NUM_STAGES]) begin
            result <= {carry_out_wire[NUM_STAGES-1], assembled_sum};
        end
    end

endmodule