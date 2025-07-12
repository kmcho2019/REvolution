module adder_pipe_64bit(
    input               clk,
    input               rst_n,
    input               i_en,
    input       [63:0]  adda,
    input       [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

    localparam STG_WIDTH = 16;
    localparam NUM_STAGES = 64 / STG_WIDTH; // 4 stages

    // Stage registers: hold operands for each stage
    reg [STG_WIDTH-1:0] a_reg [0:NUM_STAGES-1];
    reg [STG_WIDTH-1:0] b_reg [0:NUM_STAGES-1];

    // Registers for sum output of each stage
    reg [STG_WIDTH-1:0] sum_reg [0:NUM_STAGES-1];

    // Carry registers: carry_in and carry_out per stage
    reg carry_reg [0:NUM_STAGES]; // carry_reg[0] is carry_in for stage0, carry_reg[NUM_STAGES] is final carry_out

    // Enable pipeline to track valid data through pipeline stages
    reg [NUM_STAGES:0] en_pipeline;

    integer i;

    // Combinational wires for sum and carry from each stage adder
    wire [STG_WIDTH:0] stage_sum_carry [0:NUM_STAGES-1]; // [STG_WIDTH] = carry_out, [STG_WIDTH-1:0]=sum

    // Combinational adders per pipeline stage
    genvar stage;
    generate
        for (stage = 0; stage < NUM_STAGES; stage = stage + 1) begin : adder_stages
            assign stage_sum_carry[stage] = a_reg[stage] + b_reg[stage] + carry_reg[stage];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and outputs
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                a_reg[i]    <= 0;
                b_reg[i]    <= 0;
                sum_reg[i]  <= 0;
                carry_reg[i] <= 0;
            end
            carry_reg[NUM_STAGES] <= 0;
            en_pipeline <= 0;
            result <= 0;
            o_en <= 0;
        end else begin
            // Shift enable pipeline register
            en_pipeline <= {en_pipeline[NUM_STAGES-1:0], i_en};

            // At stage 0 input cycle: latch inputs into stage 0 registers and reset carry_in
            if (i_en) begin
                a_reg[0] <= adda[STG_WIDTH-1:0];
                b_reg[0] <= addb[STG_WIDTH-1:0];
                carry_reg[0] <= 1'b0; // initial carry in zero
            end else begin
                // hold stage0 inputs if no new input
                a_reg[0] <= a_reg[0];
                b_reg[0] <= b_reg[0];
                carry_reg[0] <= carry_reg[0];
            end

            // For stage 0: register sum and carry_out
            sum_reg[0] <= stage_sum_carry[0][STG_WIDTH-1:0];
            carry_reg[1] <= stage_sum_carry[0][STG_WIDTH];

            // For stages 1 to NUM_STAGES-1
            for (i = 1; i < NUM_STAGES; i = i + 1) begin
                // On the cycle when enable pipeline at i stage is asserted,
                // latch the corresponding slice of input operands into stage registers
                // and latch carry_in from previous stage's carry_out
                if (en_pipeline[i-1]) begin
                    a_reg[i] <= adda[STG_WIDTH*i +: STG_WIDTH];
                    b_reg[i] <= addb[STG_WIDTH*i +: STG_WIDTH];
                    carry_reg[i] <= carry_reg[i]; // keep old carry_reg[i] for combinational use below
                end else begin
                    // Hold previous values
                    a_reg[i] <= a_reg[i];
                    b_reg[i] <= b_reg[i];
                    carry_reg[i] <= carry_reg[i];
                end

                // Register sum and carry_out at stage i
                sum_reg[i] <= stage_sum_carry[i][STG_WIDTH-1:0];
                carry_reg[i+1] <= stage_sum_carry[i][STG_WIDTH];
            end

            // When output enable stage is asserted, output the full 65-bit sum
            if (en_pipeline[NUM_STAGES]) begin
                // Concatenate sums from MSB stage to LSB stage and final carry out
                result <= {carry_reg[NUM_STAGES],
                           sum_reg[NUM_STAGES-1],
                           sum_reg[NUM_STAGES-2],
                           sum_reg[NUM_STAGES-3],
                           sum_reg[0]};
            end else begin
                result <= result; // hold result if not valid
            end

            // Output enable signal is delayed version of i_en by pipeline length
            o_en <= en_pipeline[NUM_STAGES];
        end
    end

endmodule