module adder_pipe_64bit #(
    parameter STAGES = 8,         // Number of pipeline stages (8 * 8 = 64 bits total)
    parameter SEG_BITS = 8        // Bits per pipeline stage segment
)(
    input  wire                 clk,
    input  wire                 rst_n,
    input  wire                 i_en,
    input  wire [STAGES*SEG_BITS-1:0] adda,
    input  wire [STAGES*SEG_BITS-1:0] addb,
    output reg  [STAGES*SEG_BITS:0]   result,
    output reg                  o_en
);

    // Pipeline registers for operand segments per stage
    reg [SEG_BITS-1:0] adda_pipe   [0:STAGES-1];
    reg [SEG_BITS-1:0] addb_pipe   [0:STAGES-1];

    // Carry-in pipeline registers per stage
    reg carry_pipe [0:STAGES-1];

    // Partial sum pipeline registers per stage
    reg [SEG_BITS-1:0] sum_pipe [0:STAGES-1];

    // Output enable pipeline registers
    reg en_pipe [0:STAGES-1];

    integer i;

    // Combinational add results (sum + carry out) per stage
    wire [SEG_BITS:0] add_result [0:STAGES-1];

    // Generate combinational adders per stage
    genvar idx;
    generate
        for (idx = 0; idx < STAGES; idx = idx + 1) begin : gen_adders
            wire [SEG_BITS-1:0] a = (idx == 0) ? adda[SEG_BITS*idx +: SEG_BITS] : adda_pipe[idx];
            wire [SEG_BITS-1:0] b = (idx == 0) ? addb[SEG_BITS*idx +: SEG_BITS] : addb_pipe[idx];
            wire carry_in = (idx == 0) ? 1'b0 : carry_pipe[idx-1];
            assign add_result[idx] = a + b + carry_in;
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset outputs and pipeline registers
            result <= {(STAGES*SEG_BITS+1){1'b0}};
            o_en <= 1'b0;
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= {SEG_BITS{1'b0}};
                addb_pipe[i] <= {SEG_BITS{1'b0}};
                carry_pipe[i] <= 1'b0;
                sum_pipe[i] <= {SEG_BITS{1'b0}};
                en_pipe[i] <= 1'b0;
            end
        end else begin
            // Stage 0: load operands segments and calculate sums
            adda_pipe[0] <= adda[SEG_BITS*0 +: SEG_BITS];
            addb_pipe[0] <= addb[SEG_BITS*0 +: SEG_BITS];
            sum_pipe[0] <= add_result[0][SEG_BITS-1:0];
            carry_pipe[0] <= add_result[0][SEG_BITS];  // carry out
            en_pipe[0] <= i_en;

            // Stages 1 to STAGES-1
            for (i = 1; i < STAGES; i = i + 1) begin
                // Load operand segments directly from inputs
                adda_pipe[i] <= adda[SEG_BITS*i +: SEG_BITS];
                addb_pipe[i] <= addb[SEG_BITS*i +: SEG_BITS];
                sum_pipe[i] <= add_result[i][SEG_BITS-1:0];
                carry_pipe[i] <= add_result[i][SEG_BITS];
                en_pipe[i] <= en_pipe[i-1];
            end

            o_en <= en_pipe[STAGES-1];

            // Output result assembly when output enable is valid
            if (en_pipe[STAGES-1]) begin
                // Concatenate partial sums from MSB segment to LSB segment plus final carry out
                // sum_pipe[STAGES-1] is MSB segment, sum_pipe[0] is LSB segment
                // result = {carry_out, sum_pipe[STAGES-1], ..., sum_pipe[0]}
                result <= {carry_pipe[STAGES-1],
                           sum_pipe[STAGES-1], sum_pipe[STAGES-2], sum_pipe[STAGES-3], sum_pipe[STAGES-4],
                           sum_pipe[STAGES-5], sum_pipe[STAGES-6], sum_pipe[STAGES-7], sum_pipe[STAGES-8]}; 
                // The above line must be generic and parameterized for arbitrary STAGES.

                // So generate concatenation dynamically:
                // Since Verilog doesn't support dynamic concatenation in procedural blocks easily,
                // construct result bitwise:
                integer j;
                reg [STAGES*SEG_BITS-1:0] sum_concat;
                sum_concat = {STAGES*SEG_BITS{1'b0}};
                for (j = 0; j < STAGES; j = j + 1) begin
                    sum_concat[SEG_BITS*j +: SEG_BITS] = sum_pipe[j];
                end
                // Reverse the order since sum_pipe[0] is LSB segment, result MSB on left
                // So to get MSB to LSB order, reverse segments while concatenating:
                reg [STAGES*SEG_BITS-1:0] sum_rev;
                for (j = 0; j < STAGES; j = j + 1) begin
                    sum_rev[SEG_BITS*(STAGES-1-j) +: SEG_BITS] = sum_pipe[j];
                end
                result <= {carry_pipe[STAGES-1], sum_rev};
            end else begin
                result <= {(STAGES*SEG_BITS+1){1'b0}};
            end
        end
    end

endmodule