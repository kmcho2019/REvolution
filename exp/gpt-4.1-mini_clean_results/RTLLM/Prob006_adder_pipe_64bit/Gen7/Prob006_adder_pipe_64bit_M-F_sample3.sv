module u_pip_add64 #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 4
)(
    input                      clk,
    input                      rst_n,
    input                      i_en,
    input      [DATA_WIDTH-1:0] adda,
    input      [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0]   result,
    output reg                 o_en
);

    localparam STG_SIZE = DATA_WIDTH / STG_WIDTH; // bits per stage
    // Check integer division: must divide exactly
    initial begin
        if (DATA_WIDTH % STG_WIDTH != 0) begin
            $error("DATA_WIDTH must be divisible by STG_WIDTH");
        end
    end

    // Pipeline registers:
    // Carry pipeline: STG_WIDTH+1 elements, each 1 bit
    reg [STG_WIDTH:0] carry_pipe;
    // Partial sums pipeline: STG_WIDTH registers, each STG_SIZE bits
    reg [STG_SIZE-1:0] sum_pipe [0:STG_WIDTH-1];
    // Enable pipeline: STG_WIDTH+1 bits
    reg [STG_WIDTH:0] en_pipe;

    integer i;
    genvar gi;

    // Wires for sum+carry per stage
    wire [STG_SIZE:0] stage_sum [0:STG_WIDTH-1];

    // Calculate sum for each stage with carry in
    generate
        for (gi = 0; gi < STG_WIDTH; gi = gi + 1) begin : gen_stage_sum
            wire [STG_SIZE-1:0] a_slice = adda[(gi+1)*STG_SIZE-1 -: STG_SIZE];
            wire [STG_SIZE-1:0] b_slice = addb[(gi+1)*STG_SIZE-1 -: STG_SIZE];
            assign stage_sum[gi] = {1'b0, a_slice} + {1'b0, b_slice} + carry_pipe[gi];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            carry_pipe <= {STG_WIDTH+1{1'b0}};
            en_pipe <= {STG_WIDTH+1{1'b0}};
            for (i = 0; i < STG_WIDTH; i = i + 1) begin
                sum_pipe[i] <= {STG_SIZE{1'b0}};
            end
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Pipeline enable shift-in
            en_pipe[0] <= i_en;

            // Stage 0 carry-in always zero
            carry_pipe[0] <= 1'b0;

            // For stages 0 to STG_WIDTH-1:
            for (i = 0; i < STG_WIDTH; i = i + 1) begin
                // Register sum (lower bits)
                sum_pipe[i] <= stage_sum[i][STG_SIZE-1:0];
                // Register carry-out to carry_pipe[i+1]
                carry_pipe[i+1] <= stage_sum[i][STG_SIZE];
            end

            // Shift enable pipeline
            for (i = 1; i <= STG_WIDTH; i = i + 1) begin
                en_pipe[i] <= en_pipe[i-1];
            end

            // Concatenate output result: final carry + all partial sums
            result <= {carry_pipe[STG_WIDTH]};
            for (i = STG_WIDTH-1; i >= 0; i = i - 1) begin
                result <= {result, sum_pipe[i]};
            end

            // Output enable follows the pipeline
            o_en <= en_pipe[STG_WIDTH];
        end
    end

endmodule