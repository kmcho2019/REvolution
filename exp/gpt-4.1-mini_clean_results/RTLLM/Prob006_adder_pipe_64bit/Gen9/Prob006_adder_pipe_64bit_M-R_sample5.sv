module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = 8,
    parameter STAGES = DATA_WIDTH / STG_WIDTH
)(
    input                       clk,
    input                       rst_n,
    input                       i_en,
    input       [DATA_WIDTH-1:0] adda,
    input       [DATA_WIDTH-1:0] addb,
    output reg  [DATA_WIDTH:0]   result,
    output reg                  o_en
);

    // Pipeline registers for operand slices, enable signals, sums, and carry
    reg [STG_WIDTH-1:0] adda_pipe [0:STAGES-1];
    reg [STG_WIDTH-1:0] addb_pipe [0:STAGES-1];
    reg                 en_pipe [0:STAGES];
    reg                 carry_pipe [0:STAGES];

    // Wires for combinational addition results per stage
    wire [STG_WIDTH:0] sum_carry [0:STAGES-1];  // STG_WIDTH bits sum + carry_out

    integer i;

    // Combinational adders for each pipeline stage:
    // sum_carry[stage] = adda_pipe[stage] + addb_pipe[stage] + carry_pipe[stage]
    generate
        genvar stage_idx;
        for (stage_idx = 0; stage_idx < STAGES; stage_idx = stage_idx + 1) begin : stage_adder
            assign sum_carry[stage_idx] = adda_pipe[stage_idx] + addb_pipe[stage_idx] + carry_pipe[stage_idx];
        end
    endgenerate

    // Assemble the sum from registered sums in pipeline stages and final carry_out
    reg [DATA_WIDTH-1:0] sum_pipe [0:STAGES-1];
    always @(*) begin
        for (i = 0; i < STAGES; i = i + 1) begin
            sum_pipe[i] = sum_carry[i][STG_WIDTH-1:0];
        end
    end

    // Final assembly combinational logic
    wire [DATA_WIDTH:0] sum_assembled;
    assign sum_assembled = {
        carry_pipe[STAGES], // final carry out
        sum_pipe[STAGES-1],
        sum_pipe[STAGES-2],
        sum_pipe[STAGES-3],
        sum_pipe[STAGES-4],
        sum_pipe[STAGES-5],
        sum_pipe[STAGES-6],
        sum_pipe[STAGES-7]
    };

    // Note: Above assembly is static unrolling for STAGES=8 (64/8)
    // For flexible parameterization, use a generate block with concatenation:
    // But since Verilog does not allow dynamic concatenation easily, we will implement a function instead.
    // We will implement a function to concatenate sum_pipe array and carry_pipe[STAGES]

    // Function to pack pipeline sums and carry into result
    function [DATA_WIDTH:0] pack_sum_output;
        input integer n_stages;
        integer idx;
        begin
            pack_sum_output = { (DATA_WIDTH+1){1'b0} };
            for (idx = 0; idx < n_stages; idx = idx + 1) begin
                pack_sum_output[idx*STG_WIDTH +: STG_WIDTH] = sum_pipe[idx];
            end
            pack_sum_output[DATA_WIDTH] = carry_pipe[n_stages];
        end
    endfunction

    wire [DATA_WIDTH:0] result_next;
    assign result_next = pack_sum_output(STAGES);

    // Pipeline register update: registers inputs and propagates carry and enable signals
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= {STG_WIDTH{1'b0}};
                addb_pipe[i] <= {STG_WIDTH{1'b0}};
                carry_pipe[i] <= 1'b0;
                en_pipe[i] <= 1'b0;
            end
            carry_pipe[STAGES] <= 1'b0;
            en_pipe[STAGES] <= 1'b0;
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Load pipeline stage 0 operands and set carry_in to zero
            adda_pipe[0] <= adda[STG_WIDTH-1:0];
            addb_pipe[0] <= addb[STG_WIDTH-1:0];
            carry_pipe[0] <= 1'b0;
            en_pipe[0] <= i_en;

            // For later stages, register input slices and carry from previous stage carry_out
            for (i = 1; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= adda[i*STG_WIDTH +: STG_WIDTH];
                addb_pipe[i] <= addb[i*STG_WIDTH +: STG_WIDTH];
                carry_pipe[i] <= sum_carry[i-1][STG_WIDTH];
                en_pipe[i] <= en_pipe[i-1];
            end

            // Register final carry_out and enable signal for output stage
            carry_pipe[STAGES] <= sum_carry[STAGES-1][STG_WIDTH];
            en_pipe[STAGES] <= en_pipe[STAGES-1];

            // Update output result and output enable
            result <= result_next;
            o_en <= en_pipe[STAGES];
        end
    end

endmodule