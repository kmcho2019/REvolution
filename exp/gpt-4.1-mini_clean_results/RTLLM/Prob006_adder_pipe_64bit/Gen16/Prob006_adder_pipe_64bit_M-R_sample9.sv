module adder_pipe_64bit (
    input              clk,
    input              rst_n,
    input              i_en,
    input      [63:0]  adda,
    input      [63:0]  addb,
    output reg [64:0]  result,
    output reg         o_en
);

    localparam STG_BITS = 16;
    localparam NUM_STG  = 4;

    // Pipeline registers for input operands slices
    reg [STG_BITS-1:0] adda_pipe [0:NUM_STG-1];
    reg [STG_BITS-1:0] addb_pipe [0:NUM_STG-1];

    // Pipeline registers for partial sums
    reg [STG_BITS-1:0] sum_pipe [0:NUM_STG-1];

    // Pipeline registers for carry signals
    reg carry_pipe [0:NUM_STG]; // carry_pipe[0] is carry-in to stage 0

    // Pipeline registers for enable signals to track valid data in pipeline
    reg en_pipe [0:NUM_STG];

    integer i;

    // Combinational wires for sum and carry at each stage
    wire [STG_BITS:0] sum_carry [0:NUM_STG-1]; // [STG_BITS] = carry out

    // Generate combinational sum and carry for each stage
    generate
        genvar g;
        for (g = 0; g < NUM_STG; g = g + 1) begin : stage_add
            assign sum_carry[g] = adda_pipe[g] + addb_pipe[g] + carry_pipe[g];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            for (i = 0; i < NUM_STG; i = i + 1) begin
                adda_pipe[i] <= {STG_BITS{1'b0}};
                addb_pipe[i] <= {STG_BITS{1'b0}};
                sum_pipe[i]  <= {STG_BITS{1'b0}};
                carry_pipe[i] <= 1'b0;
                en_pipe[i] <= 1'b0;
            end
            carry_pipe[NUM_STG] <= 1'b0;
            en_pipe[NUM_STG] <= 1'b0;
            result <= {65{1'b0}};
            o_en <= 1'b0;
        end else begin
            // Stage 0 input registers and carry-in=0
            if (i_en) begin
                adda_pipe[0] <= adda[15:0];
                addb_pipe[0] <= addb[15:0];
            end else begin
                // Hold previous values if no valid input
                adda_pipe[0] <= adda_pipe[0];
                addb_pipe[0] <= addb_pipe[0];
            end
            carry_pipe[0] <= 1'b0;  // initial carry-in zero
            en_pipe[0] <= i_en;

            // Update pipeline stages 1 to NUM_STG-1 operands by slicing inputs
            // Only update if previous stage enable is high
            for (i = 1; i < NUM_STG; i = i + 1) begin
                if (en_pipe[i-1]) begin
                    adda_pipe[i] <= adda[i*STG_BITS +: STG_BITS];
                    addb_pipe[i] <= addb[i*STG_BITS +: STG_BITS];
                end else begin
                    adda_pipe[i] <= adda_pipe[i];
                    addb_pipe[i] <= addb_pipe[i];
                end
            end

            // Capture sums and propagate carries and enable signals
            for (i = 0; i < NUM_STG; i = i + 1) begin
                sum_pipe[i]   <= sum_carry[i][STG_BITS-1:0];
                carry_pipe[i+1] <= sum_carry[i][STG_BITS];
                en_pipe[i+1] <= en_pipe[i];
            end

            // Output registers
            o_en <= en_pipe[NUM_STG];
            if (en_pipe[NUM_STG]) begin
                // Concatenate sums MSB to LSB plus final carry-out
                result <= {carry_pipe[NUM_STG],
                           sum_pipe[NUM_STG-1],
                           sum_pipe[NUM_STG-2],
                           sum_pipe[NUM_STG-3],
                           sum_pipe[0]};
            end else begin
                result <= result;
            end
        end
    end

endmodule