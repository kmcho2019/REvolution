module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input      [63:0]   adda,
    input      [63:0]   addb,
    output reg [64:0]   result,
    output reg          o_en
);

    // Parameters for stage width and number of stages
    localparam STG_WIDTH = 8;
    localparam STAGES = 8;

    // Pipeline registers for sums, carries, and enable signals
    reg [STG_WIDTH-1:0] sum_reg0, sum_reg1, sum_reg2, sum_reg3;
    reg [STG_WIDTH-1:0] sum_reg4, sum_reg5, sum_reg6, sum_reg7;

    reg carry_reg1, carry_reg2, carry_reg3, carry_reg4;
    reg carry_reg5, carry_reg6, carry_reg7, carry_reg8;

    reg en_pipe1, en_pipe2, en_pipe3, en_pipe4;
    reg en_pipe5, en_pipe6, en_pipe7, en_pipe8;

    // Temporary wires for addition results with carry out
    wire [STG_WIDTH:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6, sum7;

    // First stage addition (bits 7:0)
    assign sum0 = adda[7:0] + addb[7:0];
    // Subsequent stages add inputs and carry from previous stage
    assign sum1 = adda[15:8]  + addb[15:8]  + carry_reg1;
    assign sum2 = adda[23:16] + addb[23:16] + carry_reg2;
    assign sum3 = adda[31:24] + addb[31:24] + carry_reg3;
    assign sum4 = adda[39:32] + addb[39:32] + carry_reg4;
    assign sum5 = adda[47:40] + addb[47:40] + carry_reg5;
    assign sum6 = adda[55:48] + addb[55:48] + carry_reg6;
    assign sum7 = adda[63:56] + addb[63:56] + carry_reg7;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and outputs
            sum_reg0 <= 0; sum_reg1 <= 0; sum_reg2 <= 0; sum_reg3 <= 0;
            sum_reg4 <= 0; sum_reg5 <= 0; sum_reg6 <= 0; sum_reg7 <= 0;

            carry_reg1 <= 0; carry_reg2 <= 0; carry_reg3 <= 0; carry_reg4 <= 0;
            carry_reg5 <= 0; carry_reg6 <= 0; carry_reg7 <= 0; carry_reg8 <= 0;

            en_pipe1 <= 0; en_pipe2 <= 0; en_pipe3 <= 0; en_pipe4 <= 0;
            en_pipe5 <= 0; en_pipe6 <= 0; en_pipe7 <= 0; en_pipe8 <= 0;

            result <= 0;
            o_en <= 0;
        end else begin
            // Stage 0: no carry-in and en_pipe0 = i_en
            en_pipe1 <= i_en;
            sum_reg0 <= sum0[STG_WIDTH-1:0];
            carry_reg1 <= sum0[STG_WIDTH];

            // Stage 1
            en_pipe2 <= en_pipe1;
            sum_reg1 <= sum1[STG_WIDTH-1:0];
            carry_reg2 <= sum1[STG_WIDTH];

            // Stage 2
            en_pipe3 <= en_pipe2;
            sum_reg2 <= sum2[STG_WIDTH-1:0];
            carry_reg3 <= sum2[STG_WIDTH];

            // Stage 3
            en_pipe4 <= en_pipe3;
            sum_reg3 <= sum3[STG_WIDTH-1:0];
            carry_reg4 <= sum3[STG_WIDTH];

            // Stage 4
            en_pipe5 <= en_pipe4;
            sum_reg4 <= sum4[STG_WIDTH-1:0];
            carry_reg5 <= sum4[STG_WIDTH];

            // Stage 5
            en_pipe6 <= en_pipe5;
            sum_reg5 <= sum5[STG_WIDTH-1:0];
            carry_reg6 <= sum5[STG_WIDTH];

            // Stage 6
            en_pipe7 <= en_pipe6;
            sum_reg6 <= sum6[STG_WIDTH-1:0];
            carry_reg7 <= sum6[STG_WIDTH];

            // Stage 7
            en_pipe8 <= en_pipe7;
            sum_reg7 <= sum7[STG_WIDTH-1:0];
            carry_reg8 <= sum7[STG_WIDTH];

            // Assemble final result from pipeline registers and carry out
            result <= {carry_reg8,
                       sum_reg7,
                       sum_reg6,
                       sum_reg5,
                       sum_reg4,
                       sum_reg3,
                       sum_reg2,
                       sum_reg1,
                       sum_reg0};

            // Output enable after full pipeline latency
            o_en <= en_pipe8;
        end
    end

endmodule