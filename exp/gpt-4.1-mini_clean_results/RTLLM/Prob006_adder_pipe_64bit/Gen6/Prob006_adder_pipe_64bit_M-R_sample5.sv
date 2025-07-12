module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input       [63:0]  adda,
    input       [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    // Stage 1 pipeline registers
    reg [15:0] adda_s1, addb_s1;
    reg        en_s1;
    reg        carry_s0;

    reg [15:0] sum_s1;
    reg        carry_s1;

    // Stage 2 pipeline registers
    reg [15:0] adda_s2, addb_s2;
    reg        en_s2;
    reg        carry_s2;

    reg [15:0] sum_s2;
    reg        carry_s3;

    // Stage 3 pipeline registers
    reg [15:0] adda_s3, addb_s3;
    reg        en_s3;
    reg        carry_s4;

    reg [15:0] sum_s3;
    reg        carry_s5;

    // Stage 4 pipeline registers
    reg [15:0] adda_s4, addb_s4;
    reg        en_s4;
    reg        carry_s6;

    reg [15:0] sum_s4;
    reg        carry_s7;

    // Synchronize and pipeline input operands and enable
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            adda_s1 <= 16'b0;
            addb_s1 <= 16'b0;
            en_s1   <= 1'b0;
            carry_s0 <= 1'b0;

            sum_s1 <= 16'b0;
            carry_s1 <= 1'b0;

            adda_s2 <= 16'b0;
            addb_s2 <= 16'b0;
            en_s2   <= 1'b0;
            carry_s2 <= 1'b0;

            sum_s2 <= 16'b0;
            carry_s3 <= 1'b0;

            adda_s3 <= 16'b0;
            addb_s3 <= 16'b0;
            en_s3   <= 1'b0;
            carry_s4 <= 1'b0;

            sum_s3 <= 16'b0;
            carry_s5 <= 1'b0;

            adda_s4 <= 16'b0;
            addb_s4 <= 16'b0;
            en_s4   <= 1'b0;
            carry_s6 <= 1'b0;

            sum_s4 <= 16'b0;
            carry_s7 <= 1'b0;

            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Stage 1: input registers and addition (bits 15:0)
            adda_s1 <= adda[15:0];
            addb_s1 <= addb[15:0];
            en_s1   <= i_en;
            carry_s0 <= 1'b0; // initial carry-in zero for first stage

            {carry_s1, sum_s1} <= adda_s1 + addb_s1 + carry_s0;

            // Stage 2: pipeline registers and addition (bits 31:16)
            adda_s2 <= adda[31:16];
            addb_s2 <= addb[31:16];
            en_s2   <= en_s1;
            carry_s2 <= carry_s1;

            {carry_s3, sum_s2} <= adda_s2 + addb_s2 + carry_s2;

            // Stage 3: pipeline registers and addition (bits 47:32)
            adda_s3 <= adda[47:32];
            addb_s3 <= addb[47:32];
            en_s3   <= en_s2;
            carry_s4 <= carry_s3;

            {carry_s5, sum_s3} <= adda_s3 + addb_s3 + carry_s4;

            // Stage 4: pipeline registers and addition (bits 63:48)
            adda_s4 <= adda[63:48];
            addb_s4 <= addb[63:48];
            en_s4   <= en_s3;
            carry_s6 <= carry_s5;

            {carry_s7, sum_s4} <= adda_s4 + addb_s4 + carry_s6;

            // Final result and output enable
            result <= {carry_s7, sum_s4, sum_s3, sum_s2, sum_s1};
            o_en <= en_s4;
        end
    end

endmodule