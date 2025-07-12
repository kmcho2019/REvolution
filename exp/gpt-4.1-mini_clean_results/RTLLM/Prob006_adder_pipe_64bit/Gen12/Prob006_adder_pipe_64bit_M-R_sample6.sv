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

    // Pipeline registers for sum outputs (per stage)
    reg [STG_WIDTH-1:0] sum_reg [0:STAGES-1];
    // Pipeline registers for carry signals (per stage), one extra for carry-in to first stage and carry-out of last stage
    reg                 carry_reg [0:STAGES];
    // Pipeline registers for enable signal
    reg                 en_pipe [0:STAGES];

    // Intermediate wires for stage additions (STG_WIDTH+1 bits to hold carry-out)
    wire [STG_WIDTH:0] stage_sum_w [0:STAGES-1];

    integer i;

    // Combinational adders for each stage
    generate
        genvar gi;
        for (gi = 0; gi < STAGES; gi = gi + 1) begin : gen_adders
            // Add STG_WIDTH-bit operands + 1-bit carry_in from previous stage carry_reg
            // Result is STG_WIDTH+1 bits: lower STG_WIDTH bits are sum, MSB is carry_out
            assign stage_sum_w[gi] = adda[gi*STG_WIDTH +: STG_WIDTH] + addb[gi*STG_WIDTH +: STG_WIDTH] + carry_reg[gi];
        end
    endgenerate

    // Combinational assembly of output from sum_reg and final carry_reg
    wire [DATA_WIDTH:0] result_wire;
    generate
        // Create a concatenation of all sum_reg stages and final carry
        // This requires intermediate wires to flatten sum_reg arrays because sum_reg is an array of regs
        wire [DATA_WIDTH-1:0] sum_concat;
        // Flatten sum_reg into sum_concat vector
        for (i = 0; i < STAGES; i = i + 1) begin : gen_sum_concat
            assign sum_concat[i*STG_WIDTH +: STG_WIDTH] = sum_reg[i];
        end
        assign result_wire = {carry_reg[STAGES], sum_concat};
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
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
            // Shift enable pipeline and register input enable
            en_pipe[0] <= i_en;
            for (i = 1; i <= STAGES; i = i + 1) begin
                en_pipe[i] <= en_pipe[i-1];
            end

            // Initialize carry-in for stage 0 to zero (no carry input at adder start)
            carry_reg[0] <= 1'b0;

            // For each stage, register sum and carry_out
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_reg[i] <= stage_sum_w[i][STG_WIDTH-1:0];
                carry_reg[i+1] <= stage_sum_w[i][STG_WIDTH];
            end

            // Register assembled result from pipeline registers
            result <= result_wire;

            // Output enable aligned to pipeline depth
            o_en <= en_pipe[STAGES];
        end
    end

endmodule