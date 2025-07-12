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

    // Pipeline registers for operand segments (stage 0 only)
    reg [SEG_BITS-1:0] adda_seg [0:STAGES-1];
    reg [SEG_BITS-1:0] addb_seg [0:STAGES-1];

    // Pipeline registers for carry_in, sum segments, carry_out, and enable
    reg carry_in_pipe [0:STAGES];
    reg [SEG_BITS-1:0] sum_pipe [0:STAGES-1];
    reg en_pipe [0:STAGES];

    integer i;

    // Combinational wires for sum and carry_out per stage
    wire [SEG_BITS:0] sum_carry [0:STAGES-1];

    // Split input operands into 8 segments (8 bits each)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_seg[i] <= 0;
                addb_seg[i] <= 0;
            end
        end else if (i_en) begin
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_seg[i] <= adda[SEG_BITS*i +: SEG_BITS];
                addb_seg[i] <= addb[SEG_BITS*i +: SEG_BITS];
            end
        end
    end

    // Initialize carry_in_pipe and en_pipe with reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            carry_in_pipe[0] <= 1'b0;
            en_pipe[0] <= 1'b0;
        end else begin
            // Enable input stage carries in when i_en active
            carry_in_pipe[0] <= 1'b0;  // initial carry-in zero
            en_pipe[0] <= i_en;
        end
    end

    // Generate sum and carry for each stage combinationally
    generate
        genvar stage;
        for (stage = 0; stage < STAGES; stage = stage + 1) begin : gen_sum_carry
            assign sum_carry[stage] = {1'b0, adda_seg[stage]} + {1'b0, addb_seg[stage]} + carry_in_pipe[stage];
        end
    endgenerate

    // Pipeline registers for sums, carry_outs, carries_in for next stage and enables
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= 0;
                carry_in_pipe[i+1] <= 1'b0;
                en_pipe[i+1] <= 1'b0;
            end
            result <= 0;
            o_en <= 1'b0;
        end else begin
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= sum_carry[i][SEG_BITS-1:0];
                carry_in_pipe[i+1] <= sum_carry[i][SEG_BITS];
                en_pipe[i+1] <= en_pipe[i];
            end

            o_en <= en_pipe[STAGES];

            // When output is enabled, assemble final 65-bit result
            if (en_pipe[STAGES]) begin
                result <= {carry_in_pipe[STAGES],
                           sum_pipe[STAGES-1],
                           sum_pipe[STAGES-2],
                           sum_pipe[STAGES-3],
                           sum_pipe[STAGES-4],
                           sum_pipe[STAGES-5],
                           sum_pipe[STAGES-6],
                           sum_pipe[STAGES-7],
                           sum_pipe[0]};
            end else begin
                result <= 0;
            end
        end
    end

endmodule