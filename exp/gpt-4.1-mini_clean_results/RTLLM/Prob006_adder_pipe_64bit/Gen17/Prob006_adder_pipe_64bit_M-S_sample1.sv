module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input      [63:0]   adda,
    input      [63:0]   addb,
    output reg [64:0]   result,
    output reg          o_en
);

    // Fixed parameters for pipeline
    localparam STG_WIDTH = 16;
    localparam NUM_STG = 64 / STG_WIDTH;

    // Pipeline registers for operands
    reg [STG_WIDTH-1:0] adda_reg [0:NUM_STG-1];
    reg [STG_WIDTH-1:0] addb_reg [0:NUM_STG-1];

    // Pipeline registers for carry
    reg carry_reg [0:NUM_STG];

    // Pipeline registers for enable signal
    reg en_reg [0:NUM_STG];

    // Sum registers per stage
    reg [STG_WIDTH-1:0] sum_reg [0:NUM_STG-1];

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < NUM_STG; i = i + 1) begin
                adda_reg[i] <= {STG_WIDTH{1'b0}};
                addb_reg[i] <= {STG_WIDTH{1'b0}};
                sum_reg[i]  <= {STG_WIDTH{1'b0}};
                en_reg[i]   <= 1'b0;
                carry_reg[i] <= 1'b0;
            end
            carry_reg[NUM_STG] <= 1'b0;
            en_reg[NUM_STG] <= 1'b0;
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Stage 0: load operands and carry in is 0
            if (i_en) begin
                adda_reg[0] <= adda[15:0];
                addb_reg[0] <= addb[15:0];
            end else begin
                adda_reg[0] <= adda_reg[0];
                addb_reg[0] <= addb_reg[0];
            end
            carry_reg[0] <= 1'b0;
            en_reg[0] <= i_en;

            // Stages 1 to NUM_STG-1 load operands from inputs
            for (i = 1; i < NUM_STG; i = i + 1) begin
                if (i_en) begin
                    adda_reg[i] <= adda[i*STG_WIDTH +: STG_WIDTH];
                    addb_reg[i] <= addb[i*STG_WIDTH +: STG_WIDTH];
                end else begin
                    adda_reg[i] <= adda_reg[i];
                    addb_reg[i] <= addb_reg[i];
                end
            end

            // Perform addition at each stage, register sums and carry-out
            for (i = 0; i < NUM_STG; i = i + 1) begin
                {carry_reg[i+1], sum_reg[i]} <= adda_reg[i] + addb_reg[i] + carry_reg[i];
                en_reg[i+1] <= en_reg[i];
            end

            // Output registers update
            o_en <= en_reg[NUM_STG];
            if (en_reg[NUM_STG]) begin
                // Concatenate sums from MSB stage to LSB and final carry
                result <= {carry_reg[NUM_STG],
                           sum_reg[NUM_STG-1],
                           sum_reg[NUM_STG-2],
                           sum_reg[NUM_STG-3],
                           sum_reg[NUM_STG-4]};
            end else begin
                result <= result;
            end
        end
    end

endmodule