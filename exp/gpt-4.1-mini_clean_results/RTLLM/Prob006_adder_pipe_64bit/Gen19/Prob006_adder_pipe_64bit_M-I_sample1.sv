module adder_pipe_64bit #(
    parameter WIDTH = 64,
    parameter STAGES = 4,
    parameter STAGE_WIDTH = WIDTH / STAGES
)(
    input                       clk,
    input                       rst_n,
    input                       i_en,
    input      [WIDTH-1:0]      adda,
    input      [WIDTH-1:0]      addb,
    output reg [WIDTH:0]        result,
    output reg                  o_en
);

    // Pipeline registers for carry signals between stages (carry in at stage 0 is 0)
    reg [STAGES:0] carry_pipe;
    // Pipeline registers for enable signals to track valid data through pipeline
    reg [STAGES:0] en_pipe;

    // Partial sums registers for each stage
    reg [STAGE_WIDTH-1:0] sum_pipe [0:STAGES-1];

    integer i;

    // Stage inputs (for combinational adders): operands slices
    wire [STAGE_WIDTH-1:0] a_slice [0:STAGES-1];
    wire [STAGE_WIDTH-1:0] b_slice [0:STAGES-1];

    generate
        genvar gi;
        for (gi = 0; gi < STAGES; gi = gi + 1) begin : input_slices
            assign a_slice[gi] = adda[gi*STAGE_WIDTH +: STAGE_WIDTH];
            assign b_slice[gi] = addb[gi*STAGE_WIDTH +: STAGE_WIDTH];
        end
    endgenerate

    // Combinational addition per stage with registered carry in from carry_pipe
    // sum_pipe and carry_pipe are registered sequentially
    wire [STAGE_WIDTH:0] add_stage [0:STAGES-1];
    // The carry_pipe[0] is carry-in for stage 0, always zero on reset or input stage
    wire carry_in_stage0 = carry_pipe[0];

    // Combinational adders
    generate
        genvar gj;
        for (gj = 0; gj < STAGES; gj = gj + 1) begin : adders
            assign add_stage[gj] = a_slice[gj] + b_slice[gj] + carry_pipe[gj];
        end
    endgenerate

    // Sequential logic: pipeline registers for carry, enable, partial sums
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            carry_pipe <= { (STAGES+1){1'b0} };  // carry in at stage 0 = 0
            en_pipe    <= { (STAGES+1){1'b0} };
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= {STAGE_WIDTH{1'b0}};
            end
            result <= {(WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Update pipeline enable: input enable at stage 0, shifted along pipeline
            en_pipe[0] <= i_en;
            for (i = 1; i <= STAGES; i = i + 1) begin
                en_pipe[i] <= en_pipe[i-1];
            end

            // Update carry pipeline:
            // carry_pipe[0] = 0 always as input carry
            carry_pipe[0] <= 1'b0;
            for (i = 0; i < STAGES; i = i + 1) begin
                carry_pipe[i+1] <= add_stage[i][STAGE_WIDTH]; // carry out from stage i
            end

            // Register partial sums for each stage from combinational adders
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= add_stage[i][STAGE_WIDTH-1:0];
            end

            // When enable at final stage is high, output result with carry out
            if (en_pipe[STAGES]) begin
                // Concatenate partial sums from LSB (stage 0) to MSB (stage STAGES-1),
                // then prepend final carry_pipe[STAGES] as MSB
                result <= {carry_pipe[STAGES],
                           sum_pipe[STAGES-1],
                           sum_pipe[STAGES-2],
                           sum_pipe[STAGES-3],
                           sum_pipe[0]};
                // Since STAGES=4, the order is [sum3,sum2,sum1,sum0]
                // To be generic:
                // Use a loop to concatenate sum_pipe in correct order - but Verilog does not allow concat in loop.
                // So we do manual concat as above.

                o_en <= 1'b1;
            end else begin
                result <= {(WIDTH+1){1'b0}};
                o_en <= 1'b0;
            end
        end
    end

endmodule