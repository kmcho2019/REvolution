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
    localparam STAGES = 8;

    // Wires for combinational sums and carry-outs
    wire [STG_WIDTH-1:0] sum_w [0:STAGES-1];
    wire                 carry_w [0:STAGES];

    // Registers for pipeline sums and carry-outs
    reg [STG_WIDTH-1:0] sum_reg [0:STAGES-1];
    reg                 carry_reg [0:STAGES];

    // Pipeline enable registers
    reg en_pipe [0:STAGES];

    integer i;

    // Stage 0 carry-in is zero
    assign carry_w[0] = 1'b0;

    // Combinational adders per stage
    assign {carry_w[1], sum_w[0]} = adda[7:0]   + addb[7:0]   + carry_reg[0];
    assign {carry_w[2], sum_w[1]} = adda[15:8]  + addb[15:8]  + carry_reg[1];
    assign {carry_w[3], sum_w[2]} = adda[23:16] + addb[23:16] + carry_reg[2];
    assign {carry_w[4], sum_w[3]} = adda[31:24] + addb[31:24] + carry_reg[3];
    assign {carry_w[5], sum_w[4]} = adda[39:32] + addb[39:32] + carry_reg[4];
    assign {carry_w[6], sum_w[5]} = adda[47:40] + addb[47:40] + carry_reg[5];
    assign {carry_w[7], sum_w[6]} = adda[55:48] + addb[55:48] + carry_reg[6];
    assign {carry_w[8], sum_w[7]} = adda[63:56] + addb[63:56] + carry_reg[7];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
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
            // Pipeline carry regs: carry_reg[0] <= 0 at input stage
            carry_reg[0] <= 1'b0;
            en_pipe[0] <= i_en;

            // Register sums and carry-outs per stage
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_reg[i] <= sum_w[i];
                carry_reg[i+1] <= carry_w[i+1];
                en_pipe[i+1] <= en_pipe[i];
            end

            // Register final output and enable
            result <= {carry_reg[STAGES], sum_reg[STAGES-1], sum_reg[STAGES-2], sum_reg[STAGES-3], sum_reg[STAGES-4],
                       sum_reg[STAGES-5], sum_reg[STAGES-6], sum_reg[STAGES-7], sum_reg[STAGES-8]};
            o_en <= en_pipe[STAGES];
        end
    end

endmodule