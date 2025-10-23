module adder_pipe_64bit (
    input              clk,
    input              rst_n,
    input              i_en,
    input      [63:0]  adda,
    input      [63:0]  addb,
    output reg [64:0]  result,
    output reg         o_en
);

    // Constants
    localparam STG_WIDTH = 8;
    localparam STAGES = 64 / STG_WIDTH; // 8 stages

    // Pipeline registers
    reg [STG_WIDTH-1:0] sum_reg [0:STAGES-1];
    reg                 carry_reg [0:STAGES]; // carry_reg[0] is carry-in for stage 0
    reg                 en_pipe   [0:STAGES];

    // Combinational wires for sum and carry per stage
    wire [STG_WIDTH:0] stage_sum [0:STAGES-1];

    genvar i;
    generate
        for (i = 0; i < STAGES; i = i + 1) begin : add_stages
            // Add operands slice plus carry_in
            assign stage_sum[i] = adda[i*STG_WIDTH +: STG_WIDTH] +
                                  addb[i*STG_WIDTH +: STG_WIDTH] +
                                  carry_reg[i];
        end
    endgenerate

    integer idx;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset pipeline registers and output
            for (idx = 0; idx < STAGES; idx = idx + 1) begin
                sum_reg[idx]  <= 0;
                carry_reg[idx] <= 0;
                en_pipe[idx]  <= 0;
            end
            carry_reg[STAGES] <= 0;
            en_pipe[STAGES]   <= 0;
            result           <= 0;
            o_en             <= 0;
        end else begin
            // Register enable pipeline
            en_pipe[0] <= i_en;
            for (idx = 1; idx <= STAGES; idx = idx + 1)
                en_pipe[idx] <= en_pipe[idx-1];

            // Initial carry_in = 0
            carry_reg[0] <= 1'b0;

            // Update sum and carry pipeline registers for each stage
            for (idx = 0; idx < STAGES; idx = idx + 1) begin
                sum_reg[idx]  <= stage_sum[idx][STG_WIDTH-1:0];
                carry_reg[idx+1] <= stage_sum[idx][STG_WIDTH];
            end

            // Assemble result from sum pipeline and last carry
            for (idx = 0; idx < STAGES; idx = idx + 1)
                result[idx*STG_WIDTH +: STG_WIDTH] <= sum_reg[idx];

            result[64] <= carry_reg[STAGES];

            // Output enable after pipeline delay
            o_en <= en_pipe[STAGES];
        end
    end

endmodule