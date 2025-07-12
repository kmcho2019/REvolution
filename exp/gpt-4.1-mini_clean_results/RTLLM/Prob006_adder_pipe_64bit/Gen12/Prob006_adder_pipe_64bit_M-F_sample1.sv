module adder_pipe_64bit (
    input             clk,
    input             rst_n,
    input             i_en,
    input   [63:0]    adda,
    input   [63:0]    addb,
    output reg [64:0] result,
    output reg        o_en
);

    localparam STAGES = 8;
    localparam STG_BITS = 8;

    integer i;

    // Pipeline registers for operand slices (8 bits each stage)
    reg [STG_BITS-1:0] adda_pipe   [0:STAGES-1];
    reg [STG_BITS-1:0] addb_pipe   [0:STAGES-1];

    // Registered sum outputs per stage (8 bits each)
    reg [STG_BITS-1:0] sum_pipe    [0:STAGES-1];

    // Carry_in for each stage (1 bit)
    reg carry_pipe  [0:STAGES]; // carry_pipe[0] is carry_in for stage 0

    // Enable signals per stage to track valid data
    reg en_pipe     [0:STAGES];

    // Temporary sum (9 bits) wires for each stage (combinational)
    wire [STG_BITS:0] temp_sum [0:STAGES-1];

    // Assign operand slices from pipeline registers plus carry_in and compute sums combinationally
    genvar gv;
    generate
        for (gv = 0; gv < STAGES; gv = gv + 1) begin : ADD_STAGES
            assign temp_sum[gv] = adda_pipe[gv] + addb_pipe[gv] + carry_pipe[gv];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i]  <= {STG_BITS{1'b0}};
                addb_pipe[i]  <= {STG_BITS{1'b0}};
                sum_pipe[i]   <= {STG_BITS{1'b0}};
                carry_pipe[i] <= 1'b0;
                en_pipe[i]    <= 1'b0;
            end
            carry_pipe[STAGES] <= 1'b0;
            en_pipe[STAGES]    <= 1'b0;
            result             <= {65{1'b0}};
            o_en               <= 1'b0;
        end else begin
            // Stage 0: latch operands and carry_in=0
            adda_pipe[0]  <= adda[7:0];
            addb_pipe[0]  <= addb[7:0];
            carry_pipe[0] <= 1'b0;
            en_pipe[0]    <= i_en;

            // For stages 1 to 7: latch operand slices and enable
            for (i = 1; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= adda[i*8 +: 8];
                addb_pipe[i] <= addb[i*8 +: 8];
                en_pipe[i]   <= en_pipe[i-1];
            end

            // Register sums and carry_out for each stage
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= temp_sum[i][STG_BITS-1:0];   // lower 8 bits sum
            end

            // Update carry_pipe for next stage (carry_out)
            for (i = 1; i <= STAGES; i = i + 1) begin
                carry_pipe[i] <= temp_sum[i-1][STG_BITS];
            end

            // Propagate enable to output stage
            en_pipe[STAGES] <= en_pipe[STAGES-1];

            // When output stage enable is asserted, assemble final result and output enable
            if (en_pipe[STAGES]) begin
                result <= {
                    carry_pipe[STAGES], // MSB carry out
                    sum_pipe[7],
                    sum_pipe[6],
                    sum_pipe[5],
                    sum_pipe[4],
                    sum_pipe[3],
                    sum_pipe[2],
                    sum_pipe[1],
                    sum_pipe[0]
                };
                o_en <= 1'b1;
            end else begin
                result <= {65{1'b0}};
                o_en <= 1'b0;
            end
        end
    end

endmodule