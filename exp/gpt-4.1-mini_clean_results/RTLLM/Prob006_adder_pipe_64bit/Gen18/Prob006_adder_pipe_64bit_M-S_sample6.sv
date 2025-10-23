module adder_pipe_64bit (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         i_en,
    input  wire [63:0]  adda,
    input  wire [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // Pipeline registers for inputs and carry signals
    reg [15:0] adda_stage [0:3];
    reg [15:0] addb_stage [0:3];
    reg        carry_stage [0:4];      // carry_stage[0] = 0 initial carry-in

    // Sum registers per stage
    reg [15:0] sum_stage [0:3];

    // Enable pipeline
    reg en_stage [0:4];

    integer i;

    // Sequential logic for pipeline
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i=0; i<4; i=i+1) begin
                adda_stage[i] <= 16'b0;
                addb_stage[i] <= 16'b0;
                sum_stage[i] <= 16'b0;
                carry_stage[i] <= 1'b0;
                en_stage[i] <= 1'b0;
            end
            carry_stage[4] <= 1'b0;
            en_stage[4] <= 1'b0;
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Stage 0: latch inputs and initial carry 0
            adda_stage[0] <= adda[15:0];
            addb_stage[0] <= addb[15:0];
            carry_stage[0] <= 1'b0;
            en_stage[0] <= i_en;

            // Compute sums and carries for stage 0 combinationally
            {carry_stage[1], sum_stage[0]} <= adda_stage[0] + addb_stage[0] + carry_stage[0];

            // Stage 1 registers inputs, carry, and enable from stage 0 sum and carry
            adda_stage[1] <= adda[31:16];
            addb_stage[1] <= addb[31:16];
            en_stage[1] <= en_stage[0];

            // Compute stage 1 sum and carry
            {carry_stage[2], sum_stage[1]} <= adda_stage[1] + addb_stage[1] + carry_stage[1];

            // Stage 2 registers inputs, carry, and enable
            adda_stage[2] <= adda[47:32];
            addb_stage[2] <= addb[47:32];
            en_stage[2] <= en_stage[1];

            // Compute stage 2 sum and carry
            {carry_stage[3], sum_stage[2]} <= adda_stage[2] + addb_stage[2] + carry_stage[2];

            // Stage 3 registers inputs, carry, and enable
            adda_stage[3] <= adda[63:48];
            addb_stage[3] <= addb[63:48];
            en_stage[3] <= en_stage[2];

            // Compute stage 3 sum and carry
            {carry_stage[4], sum_stage[3]} <= adda_stage[3] + addb_stage[3] + carry_stage[3];

            // Output stage registers enable
            o_en <= en_stage[3];

            // Assemble final result when valid
            if (en_stage[3]) begin
                result <= {carry_stage[4],
                           sum_stage[3], sum_stage[2], sum_stage[1], sum_stage[0]};
            end else begin
                result <= 65'b0;
            end
        end
    end

endmodule