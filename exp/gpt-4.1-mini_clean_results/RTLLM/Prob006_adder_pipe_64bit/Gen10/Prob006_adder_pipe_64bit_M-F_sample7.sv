module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 8,
    parameter STAGES     = DATA_WIDTH / STG_WIDTH
)(
    input                     clk,
    input                     rst_n,
    input                     i_en,
    input      [DATA_WIDTH-1:0] adda,
    input      [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0] result,
    output reg                o_en
);

    // Combinational sums and carry-outs wires per stage
    wire [STG_WIDTH-1:0] sum_w [0:STAGES-1];
    wire                 carry_w [0:STAGES];

    // Pipeline registers for sums and carry-outs
    reg [STG_WIDTH-1:0] sum_reg [0:STAGES-1];
    reg                 carry_reg [0:STAGES];

    // Pipeline enable signals
    reg en_pipe [0:STAGES];

    integer i;

    // Initial carry-in is zero
    assign carry_w[0] = 1'b0;

    // Generate combinational adders for each pipeline stage
    genvar gi;
    generate
        for (gi = 0; gi < STAGES; gi = gi + 1) begin : gen_adder_stages
            assign sum_w[gi]   = adda[gi*STG_WIDTH +: STG_WIDTH] + addb[gi*STG_WIDTH +: STG_WIDTH] + carry_reg[gi];
            assign carry_w[gi+1] = ((adda[gi*STG_WIDTH +: STG_WIDTH] + addb[gi*STG_WIDTH +: STG_WIDTH] + carry_reg[gi]) >> STG_WIDTH) & 1'b1;
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_reg[i] <= {STG_WIDTH{1'b0}};
                carry_reg[i] <= 1'b0;
                en_pipe[i] <= 1'b0;
            end
            carry_reg[STAGES] <= 1'b0;
            en_pipe[STAGES] <= 1'b0;
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Input stage registers
            carry_reg[0] <= 1'b0;
            en_pipe[0] <= i_en;

            // Register sums, carry-outs, and enables for each stage
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_reg[i] <= sum_w[i];
                carry_reg[i+1] <= carry_w[i+1];
                en_pipe[i+1] <= en_pipe[i];
            end

            // Concatenate all pipeline sum_reg and final carry_reg to form result
            // Using a loop to build result in the always block for clarity
            result[0 +: STG_WIDTH] = sum_reg[0];
            for (i = 1; i < STAGES; i = i + 1) begin
                result[i*STG_WIDTH +: STG_WIDTH] = sum_reg[i];
            end
            result[DATA_WIDTH] = carry_reg[STAGES]; // MSB carry out

            o_en <= en_pipe[STAGES];
        end
    end

endmodule