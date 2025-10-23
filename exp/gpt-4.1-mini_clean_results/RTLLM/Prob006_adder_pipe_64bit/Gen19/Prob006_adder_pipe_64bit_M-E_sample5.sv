module adder_pipe_64bit (
    input  wire          clk,
    input  wire          rst_n,
    input  wire          i_en,
    input  wire [63:0]   adda,
    input  wire [63:0]   addb,
    output reg  [64:0]   result,
    output reg           o_en
);

    // Number of pipeline stages: 8 (8 bits each)
    localparam STAGES = 8;
    localparam STG_WIDTH = 8;

    // Pipeline registers for operand slices
    reg [STG_WIDTH-1:0] adda_stage [0:STAGES-1];
    reg [STG_WIDTH-1:0] addb_stage [0:STAGES-1];

    // Carry pipeline registers: one extra for initial carry-in = 0
    reg carry_stage [0:STAGES];

    // Sum pipeline registers (8 bits per stage)
    reg [STG_WIDTH-1:0] sum_stage [0:STAGES-1];

    // Enable pipeline registers
    reg en_stage [0:STAGES];

    integer i;

    // Initialize carry_stage[0] = 0 on reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_stage[i] <= {STG_WIDTH{1'b0}};
                addb_stage[i] <= {STG_WIDTH{1'b0}};
                sum_stage[i]  <= {STG_WIDTH{1'b0}};
                carry_stage[i] <= 1'b0;
                en_stage[i] <= 1'b0;
            end
            carry_stage[STAGES] <= 1'b0;
            en_stage[STAGES] <= 1'b0;
            result <= {(64+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Stage 0: latch input slices and input enable, carry_in = 0
            adda_stage[0] <= adda[7:0];
            addb_stage[0] <= addb[7:0];
            carry_stage[0] <= 1'b0;
            en_stage[0] <= i_en;

            // From stage 1 to STAGES-1: latch operand slices and enable, carry from previous stage's carry_out
            for (i = 1; i < STAGES; i = i + 1) begin
                adda_stage[i] <= adda[i*STG_WIDTH +: STG_WIDTH];
                addb_stage[i] <= addb[i*STG_WIDTH +: STG_WIDTH];
                en_stage[i] <= en_stage[i-1];
                carry_stage[i] <= carry_stage[i-1];
            end
            // The last carry_stage[STAGES] will be set after summation below.

            // Calculate sum and carry-out for each stage
            // Combinational calculation and registering sum and carry-out per stage
            // To avoid combinational logic in clocked block, split in two steps
        end
    end

    // Separate combinational logic block for sums and carry outs
    reg [STG_WIDTH:0] add_res [0:STAGES-1]; // 9-bit sum to hold carry-out

    always @* begin
        for (i = 0; i < STAGES; i = i + 1) begin
            add_res[i] = adda_stage[i] + addb_stage[i] + carry_stage[i];
        end
    end

    // Register sums and carry-outs at clock edge (separate always block)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_stage[i] <= {STG_WIDTH{1'b0}};
                carry_stage[i+1] <= 1'b0;
            end
            carry_stage[0] <= 1'b0;
        end else begin
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_stage[i] <= add_res[i][STG_WIDTH-1:0];
                carry_stage[i+1] <= add_res[i][STG_WIDTH];
            end
        end
    end

    // Pipeline enable signal continued to last stage for output enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            en_stage[STAGES] <= 1'b0;
            result <= {(64+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            en_stage[STAGES] <= en_stage[STAGES-1];

            // When output enable is asserted, assemble the 65-bit result
            if (en_stage[STAGES]) begin
                // Concatenate sums and final carry-out
                result <= {carry_stage[STAGES],
                           sum_stage[STAGES-1],
                           sum_stage[STAGES-2],
                           sum_stage[STAGES-3],
                           sum_stage[STAGES-4],
                           sum_stage[STAGES-5],
                           sum_stage[STAGES-6],
                           sum_stage[STAGES-7],
                           sum_stage[0]};
            end else begin
                result <= {(64+1){1'b0}};
            end

            o_en <= en_stage[STAGES];
        end
    end

endmodule