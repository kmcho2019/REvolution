module adder_pipe_64bit (
    input             clk,
    input             rst_n,
    input             i_en,
    input      [63:0] adda,
    input      [63:0] addb,
    output reg [64:0] result,
    output reg        o_en
);

    // Stage widths and counts
    localparam STG_WIDTH = 16;
    localparam NUM_STAGES = 4;

    // Pipeline registers for operands and enable signals per stage
    reg [63:0] adda_pipe0, adda_pipe1, adda_pipe2, adda_pipe3, adda_pipe4;
    reg [63:0] addb_pipe0, addb_pipe1, addb_pipe2, addb_pipe3, addb_pipe4;
    reg        en_pipe0, en_pipe1, en_pipe2, en_pipe3, en_pipe4;

    // Pipeline registers for carry-in signals per stage (1 bit each)
    reg c_in_pipe0, c_in_pipe1, c_in_pipe2, c_in_pipe3, c_in_pipe4;

    // Partial sums and carry outs from combinational adders (per stage)
    wire [STG_WIDTH-1:0] sum0, sum1, sum2, sum3;
    wire carry0, carry1, carry2, carry3;

    // Assign carry-in of stage 0 is zero
    assign c_in_pipe0 = 1'b0;

    // Combinational adders for each 16-bit slice + carry in
    assign {carry0, sum0} = adda_pipe0[15:0]  + addb_pipe0[15:0]  + c_in_pipe0;
    assign {carry1, sum1} = adda_pipe1[31:16] + addb_pipe1[31:16] + c_in_pipe1;
    assign {carry2, sum2} = adda_pipe2[47:32] + addb_pipe2[47:32] + c_in_pipe2;
    assign {carry3, sum3} = adda_pipe3[63:48] + addb_pipe3[63:48] + c_in_pipe3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            adda_pipe0 <= 64'd0;
            adda_pipe1 <= 64'd0;
            adda_pipe2 <= 64'd0;
            adda_pipe3 <= 64'd0;
            adda_pipe4 <= 64'd0;

            addb_pipe0 <= 64'd0;
            addb_pipe1 <= 64'd0;
            addb_pipe2 <= 64'd0;
            addb_pipe3 <= 64'd0;
            addb_pipe4 <= 64'd0;

            en_pipe0 <= 1'b0;
            en_pipe1 <= 1'b0;
            en_pipe2 <= 1'b0;
            en_pipe3 <= 1'b0;
            en_pipe4 <= 1'b0;

            c_in_pipe0 <= 1'b0;
            c_in_pipe1 <= 1'b0;
            c_in_pipe2 <= 1'b0;
            c_in_pipe3 <= 1'b0;
            c_in_pipe4 <= 1'b0;

            result <= 65'd0;
            o_en <= 1'b0;
        end else begin
            // Load inputs at stage 0
            adda_pipe0 <= adda;
            addb_pipe0 <= addb;
            en_pipe0 <= i_en;
            c_in_pipe0 <= 1'b0; // initial carry in

            // Stage 1 pipeline registers
            adda_pipe1 <= adda_pipe0;
            addb_pipe1 <= addb_pipe0;
            en_pipe1 <= en_pipe0;
            c_in_pipe1 <= carry0;

            // Stage 2 pipeline registers
            adda_pipe2 <= adda_pipe1;
            addb_pipe2 <= addb_pipe1;
            en_pipe2 <= en_pipe1;
            c_in_pipe2 <= carry1;

            // Stage 3 pipeline registers
            adda_pipe3 <= adda_pipe2;
            addb_pipe3 <= addb_pipe2;
            en_pipe3 <= en_pipe2;
            c_in_pipe3 <= carry2;

            // Stage 4 pipeline registers (to capture final carry out and enable)
            adda_pipe4 <= adda_pipe3;
            addb_pipe4 <= addb_pipe3;
            en_pipe4 <= en_pipe3;
            c_in_pipe4 <= carry3;

            // Output assignment and enable signal
            if (en_pipe4) begin
                result <= {c_in_pipe4,
                           sum3,
                           sum2,
                           sum1,
                           sum0};
                o_en <= 1'b1;
            end else begin
                result <= 65'd0;
                o_en <= 1'b0;
            end
        end
    end

endmodule