module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input       [63:0]  adda,
    input       [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    localparam STG_WIDTH = 8;
    localparam STAGES = 8; // 64/8

    // Pipeline registers for sums and carries
    reg [STG_WIDTH-1:0] sum_reg [0:STAGES-1];
    reg                 carry_reg [0:STAGES]; // carry_reg[0] = carry into stage 0

    // Pipeline enable registers
    reg en_pipe [0:STAGES];

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset pipeline registers
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_reg[i] <= 0;
                carry_reg[i] <= 0;
                en_pipe[i] <= 0;
            end
            carry_reg[STAGES] <= 0;
            en_pipe[STAGES] <= 0;

            result <= 0;
            o_en <= 0;
        end else begin
            // Stage 0 carry-in is zero
            carry_reg[0] <= 1'b0;
            en_pipe[0] <= i_en;

            // Stage 0 addition
            {carry_reg[1], sum_reg[0]} <= adda[7:0] + addb[7:0] + carry_reg[0];
            en_pipe[1] <= en_pipe[0];

            // Subsequent stages 1 to 7
            {carry_reg[2], sum_reg[1]} <= adda[15:8] + addb[15:8] + carry_reg[1];
            en_pipe[2] <= en_pipe[1];

            {carry_reg[3], sum_reg[2]} <= adda[23:16] + addb[23:16] + carry_reg[2];
            en_pipe[3] <= en_pipe[2];

            {carry_reg[4], sum_reg[3]} <= adda[31:24] + addb[31:24] + carry_reg[3];
            en_pipe[4] <= en_pipe[3];

            {carry_reg[5], sum_reg[4]} <= adda[39:32] + addb[39:32] + carry_reg[4];
            en_pipe[5] <= en_pipe[4];

            {carry_reg[6], sum_reg[5]} <= adda[47:40] + addb[47:40] + carry_reg[5];
            en_pipe[6] <= en_pipe[5];

            {carry_reg[7], sum_reg[6]} <= adda[55:48] + addb[55:48] + carry_reg[6];
            en_pipe[7] <= en_pipe[6];

            {carry_reg[8], sum_reg[7]} <= adda[63:56] + addb[63:56] + carry_reg[7];
            en_pipe[8] <= en_pipe[7];

            // Register final output and enable
            result <= {carry_reg[8], sum_reg[7], sum_reg[6], sum_reg[5], sum_reg[4], sum_reg[3], sum_reg[2], sum_reg[1], sum_reg[0]};
            o_en <= en_pipe[8];
        end
    end

endmodule