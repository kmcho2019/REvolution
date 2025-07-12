module adder_pipe_64bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        i_en,
    input  wire [63:0] adda,
    input  wire [63:0] addb,
    output reg  [64:0] result,
    output reg         o_en
);

    localparam STAGES = 8;
    localparam SEG_BITS = 8;

    // Pipeline registers for operands segments
    reg [SEG_BITS-1:0] adda_pipe   [0:STAGES-1];
    reg [SEG_BITS-1:0] addb_pipe   [0:STAGES-1];

    // Pipeline registers for carry in to each stage
    reg carry_pipe [0:STAGES-1];

    // Pipeline registers for partial sums per stage
    reg [SEG_BITS-1:0] sum_pipe [0:STAGES-1];

    // Pipeline registers for output enable signal
    reg en_pipe [0:STAGES-1];

    integer i;

    // Combinational wires for sum and carry out at each stage
    wire [SEG_BITS:0] add_result [0:STAGES-1];

    // Stage 0 carry in is always zero
    wire carry_in_0 = 1'b0;

    // Combinational adders: each stage adds operand slices and carry in
    generate
        genvar idx;
        for (idx = 0; idx < STAGES; idx = idx + 1) begin : gen_adders
            wire [SEG_BITS-1:0] a = (idx == 0) ? adda[SEG_BITS*0 +: SEG_BITS] : adda_pipe[idx];
            wire [SEG_BITS-1:0] b = (idx == 0) ? addb[SEG_BITS*0 +: SEG_BITS] : addb_pipe[idx];
            wire carry_in = (idx == 0) ? carry_in_0 : carry_pipe[idx];

            assign add_result[idx] = {1'b0, a} + {1'b0, b} + carry_in;
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 65'd0;
            o_en <= 1'b0;
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= {SEG_BITS{1'b0}};
                addb_pipe[i] <= {SEG_BITS{1'b0}};
                carry_pipe[i] <= 1'b0;
                sum_pipe[i] <= {SEG_BITS{1'b0}};
                en_pipe[i] <= 1'b0;
            end
        end else begin
            // Pipeline stage 0 inputs and enable
            adda_pipe[0] <= adda[SEG_BITS*0 +: SEG_BITS];
            addb_pipe[0] <= addb[SEG_BITS*0 +: SEG_BITS];
            carry_pipe[0] <= 1'b0; // initial carry-in zero
            sum_pipe[0] <= add_result[0][SEG_BITS-1:0];
            en_pipe[0] <= i_en;

            // Pipeline stages 1 to 7
            for (i = 1; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= adda[SEG_BITS*i +: SEG_BITS];
                addb_pipe[i] <= addb[SEG_BITS*i +: SEG_BITS];
                carry_pipe[i] <= add_result[i-1][SEG_BITS]; // carry_out from previous stage
                sum_pipe[i] <= add_result[i][SEG_BITS-1:0];
                en_pipe[i] <= en_pipe[i-1];
            end

            // Output enable delayed through pipeline
            o_en <= en_pipe[STAGES-1];

            // When output enable is high, assemble result with all sum segments and final carry
            if (en_pipe[STAGES-1]) begin
                // Concatenate sums in MSB to LSB order plus final carry_out
                result <= {add_result[STAGES-1][SEG_BITS], 
                           sum_pipe[STAGES-1], sum_pipe[STAGES-2], sum_pipe[STAGES-3], sum_pipe[STAGES-4],
                           sum_pipe[STAGES-5], sum_pipe[STAGES-6], sum_pipe[STAGES-7], sum_pipe[0]};
                // The order above is incorrect (missing some segments and wrong order),
                // Correct concatenation below:
            end else begin
                result <= 65'd0;
            end
        end
    end

    // Correct result concatenation:
    // sum_pipe array indices from 0 (LSB segment) to 7 (MSB segment)
    // So for 64 bits sum, concatenate sum_pipe[7], sum_pipe[6], ..., sum_pipe[0]
    // plus carry_out from last stage which is add_result[7][8]

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 65'd0;
        end else if (o_en) begin
            result <= {add_result[STAGES-1][SEG_BITS], 
                      sum_pipe[7], sum_pipe[6], sum_pipe[5], sum_pipe[4], sum_pipe[3], sum_pipe[2], sum_pipe[1], sum_pipe[0]};
        end else begin
            result <= 65'd0;
        end
    end

endmodule