module adder_pipe_64bit (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         i_en,
    input  wire [63:0]  adda,
    input  wire [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // Parameters for pipeline stages
    localparam STAGES = 4;
    localparam WIDTH_PER_STAGE = 16;

    // Stage registers for operands slices
    reg [WIDTH_PER_STAGE-1:0] adda_stages [0:STAGES-1];
    reg [WIDTH_PER_STAGE-1:0] addb_stages [0:STAGES-1];
    reg                      i_en_stages [0:STAGES]; // pipeline enable signal registers

    // Carry registers between stages
    reg carry [0:STAGES];

    // Partial sum registers per stage
    reg [WIDTH_PER_STAGE-1:0] sum_stages [0:STAGES-1];

    integer i;

    // Pipeline the inputs and i_en
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_stages[i] <= 0;
                addb_stages[i] <= 0;
                sum_stages[i] <= 0;
                carry[i] <= 0;
                i_en_stages[i] <= 0;
            end
            carry[STAGES] <= 0;
            i_en_stages[STAGES] <= 0;
            result <= 0;
            o_en <= 0;
        end else begin
            // Pipeline the enable signal
            i_en_stages[0] <= i_en;

            // Pipeline input operands slices
            if (i_en) begin
                for (i = 0; i < STAGES; i = i + 1) begin
                    adda_stages[i] <= adda[i*WIDTH_PER_STAGE +: WIDTH_PER_STAGE];
                    addb_stages[i] <= addb[i*WIDTH_PER_STAGE +: WIDTH_PER_STAGE];
                end
            end else begin
                for (i = 0; i < STAGES; i = i + 1) begin
                    // Hold previous values to avoid glitching sums, or zero? We can hold
                    adda_stages[i] <= adda_stages[i];
                    addb_stages[i] <= addb_stages[i];
                end
            end

            // Compute stage 0 sum and carry
            if (i_en_stages[0]) begin
                {carry[0], sum_stages[0]} <= adda_stages[0] + addb_stages[0];
            end else begin
                sum_stages[0] <= sum_stages[0];
                carry[0] <= carry[0];
            end

            // For stages 1 to STAGES-1, add with carry from previous stage
            for (i = 1; i < STAGES; i = i + 1) begin
                if (i_en_stages[i]) begin
                    {carry[i], sum_stages[i]} <= adda_stages[i] + addb_stages[i] + carry[i-1];
                end else begin
                    sum_stages[i] <= sum_stages[i];
                    carry[i] <= carry[i];
                end
            end

            // Pipeline carry-out and i_en signals
            carry[STAGES] <= carry[STAGES-1];
            i_en_stages[STAGES] <= i_en_stages[STAGES-1];

            // When final stage valid, assemble result and assert output enable
            if (i_en_stages[STAGES]) begin
                result <= {carry[STAGES], sum_stages[STAGES-1], sum_stages[STAGES-2], sum_stages[STAGES-3], sum_stages[0]};
                o_en <= 1'b1;
            end else begin
                result <= result;
                o_en <= 1'b0;
            end
        end
    end

endmodule