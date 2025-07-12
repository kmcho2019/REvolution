module adder_pipe_64bit (
    input             clk,
    input             rst_n,
    input             i_en,
    input      [63:0] adda,
    input      [63:0] addb,
    output reg [64:0] result,
    output reg        o_en
);

    // Number of pipeline stages and width per stage
    localparam STAGES = 4;
    localparam WIDTH = 16;

    // Pipeline stage registers: operands, enable, partial sums, carries
    reg [63:0] adda_stage [0:STAGES];
    reg [63:0] addb_stage [0:STAGES];
    reg        en_stage   [0:STAGES];

    reg [WIDTH-1:0] sum_stage [0:STAGES-1];  // partial sums per stage
    reg carry_stage [0:STAGES];              // carry between stages

    // Combinational adder results for each stage (16 bits + carry)
    wire [WIDTH:0] sum_carry [0:STAGES-1];

    // Assign slices and carry-in for each stage adder
    assign sum_carry[0] = adda_stage[0][15:0] + addb_stage[0][15:0] + carry_stage[0];
    assign sum_carry[1] = adda_stage[1][31:16] + addb_stage[1][31:16] + carry_stage[1];
    assign sum_carry[2] = adda_stage[2][47:32] + addb_stage[2][47:32] + carry_stage[2];
    assign sum_carry[3] = adda_stage[3][63:48] + addb_stage[3][63:48] + carry_stage[3];

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            for (i = 0; i <= STAGES; i = i + 1) begin
                adda_stage[i] <= 64'd0;
                addb_stage[i] <= 64'd0;
                en_stage[i] <= 1'b0;
                carry_stage[i] <= 1'b0;
            end
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_stage[i] <= {WIDTH{1'b0}};
            end
            result <= 65'd0;
            o_en <= 1'b0;
        end else begin
            // Stage 0 input registers
            adda_stage[0] <= adda;
            addb_stage[0] <= addb;
            en_stage[0] <= i_en;
            carry_stage[0] <= 1'b0; // initial carry-in zero

            // Capture sums and carry-outs from combinational adders into pipeline registers
            // Stage 0 sum and carry
            sum_stage[0] <= sum_carry[0][WIDTH-1:0];
            carry_stage[1] <= sum_carry[0][WIDTH];

            // For stages 1 to 3, propagate pipeline registers and capture sums and carries
            for (i = 1; i < STAGES; i = i + 1) begin
                adda_stage[i] <= adda_stage[i-1];
                addb_stage[i] <= addb_stage[i-1];
                en_stage[i] <= en_stage[i-1];

                sum_stage[i] <= sum_carry[i][WIDTH-1:0];
                carry_stage[i+1] <= sum_carry[i][WIDTH];
            end

            // Propagate enable for final output stage
            en_stage[STAGES] <= en_stage[STAGES-1];
            // Operands registers also propagated but unused after final stage
            adda_stage[STAGES] <= adda_stage[STAGES-1];
            addb_stage[STAGES] <= addb_stage[STAGES-1];

            // When output is valid, assemble final result and set output enable
            if (en_stage[STAGES]) begin
                // Concatenate sums in order from LSB stage 0 to MSB stage 3 plus final carry-out
                result <= {carry_stage[STAGES],
                           sum_stage[3],
                           sum_stage[2],
                           sum_stage[1],
                           sum_stage[0]};
                o_en <= 1'b1;
            end else begin
                result <= 65'd0;
                o_en <= 1'b0;
            end
        end
    end

endmodule