module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input      [63:0]   adda,
    input      [63:0]   addb,
    output reg [64:0]   result,
    output reg          o_en
);

    localparam STAGE_BITS = 8;
    localparam STAGES = 8;

    reg [STAGE_BITS-1:0] sum_regs [0:STAGES-1];
    reg carry_regs [0:STAGES]; // carry_regs[0] is carry-in = 0
    reg en_regs [0:STAGES];    // pipeline enable signals

    integer i;

    // Combinational sums for each stage (with carry-in)
    wire [STAGE_BITS:0] sum_wires [0:STAGES-1];

    assign carry_regs[0] = 1'b0; // initial carry-in is zero

    // Calculate sum for each stage combinationally using registered carry from previous stage
    genvar idx;
    generate
        for (idx = 0; idx < STAGES; idx = idx + 1) begin : ADD_STAGES
            assign sum_wires[idx] = adda[STAGE_BITS*idx +: STAGE_BITS] + addb[STAGE_BITS*idx +: STAGE_BITS] + carry_regs[idx];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_regs[i] <= 0;
                carry_regs[i+1] <= 0;
                en_regs[i] <= 0;
            end
            en_regs[STAGES] <= 0;
            result <= 0;
            o_en <= 0;
        end else begin
            en_regs[0] <= i_en;
            for (i = 0; i < STAGES; i = i + 1) begin
                if(i > 0)
                    carry_regs[i] <= sum_wires[i-1][STAGE_BITS];
                sum_regs[i] <= sum_wires[i][STAGE_BITS-1:0];
                if (i > 0)
                    en_regs[i] <= en_regs[i-1];
            end
            carry_regs[STAGES] <= sum_wires[STAGES-1][STAGE_BITS];
            en_regs[STAGES] <= en_regs[STAGES-1];

            // Assemble result when valid
            if (en_regs[STAGES]) begin
                result <= {carry_regs[STAGES],
                           sum_regs[STAGES-1],
                           sum_regs[STAGES-2],
                           sum_regs[STAGES-3],
                           sum_regs[STAGES-4],
                           sum_regs[STAGES-5],
                           sum_regs[STAGES-6],
                           sum_regs[STAGES-7],
                           sum_regs[0]};
                o_en <= 1'b1;
            end else begin
                o_en <= 1'b0;
            end
        end
    end

endmodule