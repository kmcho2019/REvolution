module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 8
)(
    input                       clk,
    input                       rst_n,
    input                       i_en,
    input  [DATA_WIDTH-1:0]     adda,
    input  [DATA_WIDTH-1:0]     addb,
    output reg [DATA_WIDTH:0]   result,
    output reg                  o_en
);

    // Check that DATA_WIDTH is multiple of STG_WIDTH at elaboration time
    initial begin
        if (DATA_WIDTH % STG_WIDTH != 0) begin
            $error("DATA_WIDTH (%0d) must be a multiple of STG_WIDTH (%0d)", DATA_WIDTH, STG_WIDTH);
            $finish;
        end
    end

    localparam STAGES = DATA_WIDTH / STG_WIDTH;

    integer i;

    // Pipeline registers for operand slices (STG_WIDTH bits each stage)
    reg [STG_WIDTH-1:0] adda_pipe   [0:STAGES-1];
    reg [STG_WIDTH-1:0] addb_pipe   [0:STAGES-1];

    // Registered sum outputs per stage (STG_WIDTH bits each)
    reg [STG_WIDTH-1:0] sum_pipe    [0:STAGES-1];

    // Carry_in for each stage (1 bit)
    reg carry_pipe  [0:STAGES]; // carry_pipe[0] is carry_in for stage 0, carry_pipe[STAGES] final carry out

    // Enable signals per stage to track valid data
    reg en_pipe     [0:STAGES];

    // Temporary sum (STG_WIDTH+1 bits) wires for each stage (combinational)
    wire [STG_WIDTH:0] temp_sum [0:STAGES-1];

    // Combinational addition per stage: operands + carry_in
    genvar gv;
    generate
        for (gv = 0; gv < STAGES; gv = gv + 1) begin : ADD_STAGES
            assign temp_sum[gv] = adda_pipe[gv] + addb_pipe[gv] + carry_pipe[gv];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Initialize pipeline registers and outputs to zero
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i]  <= {STG_WIDTH{1'b0}};
                addb_pipe[i]  <= {STG_WIDTH{1'b0}};
                sum_pipe[i]   <= {STG_WIDTH{1'b0}};
                carry_pipe[i] <= 1'b0;
                en_pipe[i]    <= 1'b0;
            end
            carry_pipe[STAGES] <= 1'b0;
            en_pipe[STAGES]    <= 1'b0;
            result             <= {(DATA_WIDTH+1){1'b0}};
            o_en               <= 1'b0;
        end else begin
            // Pipeline data movement and computation

            // Stage 0: load operands and input enable when i_en is high
            if (i_en) begin
                adda_pipe[0] <= adda[STG_WIDTH-1:0];
                addb_pipe[0] <= addb[STG_WIDTH-1:0];
                en_pipe[0]   <= 1'b1;
            end else begin
                // If no input enable, invalidate stage 0 data
                adda_pipe[0] <= {STG_WIDTH{1'b0}};
                addb_pipe[0] <= {STG_WIDTH{1'b0}};
                en_pipe[0]   <= 1'b0;
            end
            carry_pipe[0] <= 1'b0; // No carry-in at stage 0

            // Stages 1 to STAGES-1: propagate operands, enable, and carry from previous stage
            for (i = 1; i < STAGES; i = i + 1) begin
                adda_pipe[i]  <= adda_pipe[i-1];
                addb_pipe[i]  <= addb_pipe[i-1];
                carry_pipe[i] <= temp_sum[i-1][STG_WIDTH]; // carry out from previous stage sum
                en_pipe[i]    <= en_pipe[i-1];
            end

            // Compute sums for all stages and register results
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= temp_sum[i][STG_WIDTH-1:0];
            end

            // Final carry (carry out of last stage) to carry_pipe[STAGES]
            carry_pipe[STAGES] <= temp_sum[STAGES-1][STG_WIDTH];

            // Propagate enable to output stage
            en_pipe[STAGES] <= en_pipe[STAGES-1];

            // When output stage enable asserted, assemble full (DATA_WIDTH+1)-bit sum
            if (en_pipe[STAGES]) begin
                reg [DATA_WIDTH:0] sum_assembled;
                // Concatenate sums LSB to MSB (stage 0 is LSB)
                for (i = 0; i < STAGES; i = i + 1) begin
                    sum_assembled[i*STG_WIDTH +: STG_WIDTH] = sum_pipe[i];
                end
                sum_assembled[DATA_WIDTH] = carry_pipe[STAGES];

                result <= sum_assembled;
                o_en   <= 1'b1;
            end else begin
                result <= {(DATA_WIDTH+1){1'b0}};
                o_en   <= 1'b0;
            end
        end
    end

endmodule