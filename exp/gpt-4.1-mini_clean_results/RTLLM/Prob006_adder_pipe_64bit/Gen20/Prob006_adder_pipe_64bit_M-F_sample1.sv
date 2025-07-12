module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 16
)(
    input                       clk,
    input                       rst_n,
    input                       i_en,
    input      [DATA_WIDTH-1:0] adda,
    input      [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0]   result,
    output reg                  o_en
);

    // Number of stages inferred from DATA_WIDTH and STG_WIDTH
    localparam STAGES = DATA_WIDTH / STG_WIDTH;

    // Pipeline registers for carry signals between stages (carry in at stage 0 is 0)
    reg [STAGES:0] carry_pipe;
    // Pipeline registers for enable signals to track valid data through pipeline
    reg [STAGES:0] en_pipe;

    // Partial sums registers for each stage
    reg [STG_WIDTH-1:0] sum_pipe [0:STAGES-1];

    integer i;

    // Stage inputs (for combinational adders): operands slices
    wire [STG_WIDTH-1:0] a_slice [0:STAGES-1];
    wire [STG_WIDTH-1:0] b_slice [0:STAGES-1];

    generate
        genvar gi;
        for (gi = 0; gi < STAGES; gi = gi + 1) begin : input_slices
            assign a_slice[gi] = adda[gi*STG_WIDTH +: STG_WIDTH];
            assign b_slice[gi] = addb[gi*STG_WIDTH +: STG_WIDTH];
        end
    endgenerate

    // Combinational addition per stage with registered carry in from carry_pipe
    wire [STG_WIDTH:0] add_stage [0:STAGES-1];

    generate
        genvar gj;
        for (gj = 0; gj < STAGES; gj = gj + 1) begin : adders
            assign add_stage[gj] = a_slice[gj] + b_slice[gj] + carry_pipe[gj];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            carry_pipe <= { (STAGES+1){1'b0} };
            en_pipe    <= { (STAGES+1){1'b0} };
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= {STG_WIDTH{1'b0}};
            end
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Shift enable signal through pipeline
            en_pipe[0] <= i_en;
            for (i = 1; i <= STAGES; i = i + 1) begin
                en_pipe[i] <= en_pipe[i-1];
            end

            // carry_pipe[0] is input carry = 0
            carry_pipe[0] <= 1'b0;
            // Capture carry out from each stage add
            for (i = 0; i < STAGES; i = i + 1) begin
                carry_pipe[i+1] <= add_stage[i][STG_WIDTH];
            end

            // Register partial sums
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= add_stage[i][STG_WIDTH-1:0];
            end

            if (en_pipe[STAGES]) begin
                // Build the result concatenating sum_pipe[0] as LSB ... sum_pipe[STAGES-1] as MSB, plus final carry
                // Verilog doesn't allow variable-length concatenation loops, so build in a temp reg
                reg [DATA_WIDTH-1:0] concatenated_sum;
                integer j;
                concatenated_sum = {DATA_WIDTH{1'b0}};
                for (j = 0; j < STAGES; j = j + 1) begin
                    concatenated_sum = concatenated_sum | (sum_pipe[j] << (j*STG_WIDTH));
                end
                result <= {carry_pipe[STAGES], concatenated_sum};
                o_en <= 1'b1;
            end else begin
                result <= {(DATA_WIDTH+1){1'b0}};
                o_en <= 1'b0;
            end
        end
    end

endmodule