module adder_pipe_64bit (
    input               clk,
    input               rst_n,
    input               i_en,
    input      [63:0]   adda,
    input      [63:0]   addb,
    output reg [64:0]   result,
    output reg          o_en
);

    // Parameters
    localparam STAGES = 8;            // Number of pipeline stages
    localparam WIDTH = 8;             // Bits per pipeline stage

    // Pipeline registers: each stage holds operands segment, carry-in, partial sum, enable
    reg [WIDTH-1:0] adda_pipe   [0:STAGES-1];
    reg [WIDTH-1:0] addb_pipe   [0:STAGES-1];
    reg             carry_pipe  [0:STAGES]; // carry_pipe[0] is carry-in to stage 0 (zero)
    reg [WIDTH-1:0] sum_pipe    [0:STAGES-1];
    reg             en_pipe     [0:STAGES];

    integer i;

    // At reset, clear all pipeline registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= 0;
                addb_pipe[i] <= 0;
                sum_pipe[i]  <= 0;
                carry_pipe[i] <= 0;
                en_pipe[i] <= 0;
            end
            carry_pipe[STAGES] <= 0;
            en_pipe[STAGES] <= 0;
            result <= 0;
            o_en <= 0;
        end else begin
            // Stage 0: load input operands and enable when i_en asserted
            if (i_en) begin
                for (i = 0; i < STAGES; i = i + 1) begin
                    adda_pipe[i] <= adda[ (i+1)*WIDTH-1 -: WIDTH ];
                    addb_pipe[i] <= addb[ (i+1)*WIDTH-1 -: WIDTH ];
                end
                carry_pipe[0] <= 1'b0; // initial carry-in zero
                en_pipe[0] <= 1'b1;    // input enable for stage 0
            end else begin
                // If no new input, hold previous values or zero enable
                for (i = 0; i < STAGES; i = i + 1) begin
                    adda_pipe[i] <= adda_pipe[i];
                    addb_pipe[i] <= addb_pipe[i];
                end
                carry_pipe[0] <= carry_pipe[0];
                en_pipe[0] <= 1'b0;   // no new enable
            end

            // Propagate carry and enable through pipeline stages
            for (i = 0; i < STAGES; i = i + 1) begin
                // Perform addition for stage i if enabled at this stage
                if (en_pipe[i]) begin
                    // 8-bit addition with carry-in
                    {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
                end else begin
                    sum_pipe[i] <= sum_pipe[i];       // hold previous sum
                    carry_pipe[i+1] <= carry_pipe[i+1]; // hold previous carry
                end
            end

            // Shift enable to next stage
            for (i = 0; i < STAGES; i = i + 1) begin
                en_pipe[i+1] <= en_pipe[i];
            end

            // Output valid and assemble final result when last stage enable is asserted
            o_en <= en_pipe[STAGES];
            if (en_pipe[STAGES]) begin
                // Assemble 64-bit sum by concatenating sums from stages 0 to 7
                // sum_pipe[0] = bits[7:0], sum_pipe[1] = bits[15:8], ...
                // Concatenate in order MSB stage last
                result <= {carry_pipe[STAGES],
                           sum_pipe[STAGES-1],
                           sum_pipe[STAGES-2],
                           sum_pipe[STAGES-3],
                           sum_pipe[STAGES-4],
                           sum_pipe[STAGES-5],
                           sum_pipe[STAGES-6],
                           sum_pipe[STAGES-7],
                           sum_pipe[STAGES-8]};
                // sum_pipe[STAGES-8] is sum_pipe[0]
            end else begin
                result <= 0;
            end
        end
    end

endmodule