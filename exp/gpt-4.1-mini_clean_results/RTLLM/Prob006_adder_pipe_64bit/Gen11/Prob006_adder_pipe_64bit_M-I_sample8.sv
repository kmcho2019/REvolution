module adder_pipe_64bit (
    input              clk,
    input              rst_n,
    input              i_en,
    input      [63:0]  adda,
    input      [63:0]  addb,
    output reg [64:0]  result,
    output reg         o_en
);

    // Number of pipeline stages
    localparam STAGES = 8;
    localparam STG_BITS = 8;

    // Pipeline registers for sum parts
    reg [STG_BITS-1:0] sum_regs [0:STAGES-1];
    // Pipeline registers for carry between stages
    reg carry_regs [0:STAGES];
    // Pipeline registers for enable signal
    reg en_regs [0:STAGES];

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_regs[i] <= 0;
                carry_regs[i] <= 0;
                en_regs[i] <= 0;
            end
            carry_regs[STAGES] <= 0;
            en_regs[STAGES] <= 0;
            result <= 0;
            o_en <= 0;
        end else begin
            // Stage 0: latch input enable and carry-in=0
            carry_regs[0] <= 1'b0;
            en_regs[0] <= i_en;

            // Perform addition stage 0
            // Add lowest 8 bits plus carry_in
            {carry_regs[1], sum_regs[0]} <= adda[7:0] + addb[7:0] + carry_regs[0];
            en_regs[1] <= en_regs[0];

            // Stages 1 to 7
            for (i = 1; i < STAGES; i = i + 1) begin
                // Add next 8 bits + carry_in from previous stage
                {carry_regs[i+1], sum_regs[i]} <= adda[8*i +: 8] + addb[8*i +: 8] + carry_regs[i];
                en_regs[i+1] <= en_regs[i];
            end

            // At the end of pipeline, combine sums and final carry to form the result
            // result = {final_carry, sum_stage7, ..., sum_stage0}
            result <= {carry_regs[STAGES],
                       sum_regs[7], sum_regs[6], sum_regs[5], sum_regs[4],
                       sum_regs[3], sum_regs[2], sum_regs[1], sum_regs[0]};
            o_en <= en_regs[STAGES];
        end
    end

endmodule