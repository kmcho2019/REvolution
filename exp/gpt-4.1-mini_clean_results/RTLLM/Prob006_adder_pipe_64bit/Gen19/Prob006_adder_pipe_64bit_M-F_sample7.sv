module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 16
)(
    input  wire                  clk,
    input  wire                  rst_n,
    input  wire                  i_en,
    input  wire [DATA_WIDTH-1:0] adda,
    input  wire [DATA_WIDTH-1:0] addb,
    output reg  [DATA_WIDTH:0]   result,
    output reg                   o_en
);

    // Number of pipeline stages
    localparam STAGES = DATA_WIDTH / STG_WIDTH; // 4 stages for 64-bit and 16-bit slices

    // Pipeline registers for operands, carry-in, enable
    reg [STG_WIDTH-1:0] adda_stage [0:STAGES-1];
    reg [STG_WIDTH-1:0] addb_stage [0:STAGES-1];
    reg                 carry_in_stage [0:STAGES];  // carry_in_stage[0] = 0 initial carry-in
    reg                 en_stage [0:STAGES];

    // Sum outputs (registered)
    reg [STG_WIDTH-1:0] sum_stage [0:STAGES-1];

    // Combinational wires for sum and carry-out per stage
    wire [STG_WIDTH-1:0] sum_comb [0:STAGES-1];
    wire                 carry_out_comb [0:STAGES-1];

    integer i;

    // Combinational addition for each stage
    genvar idx;
    generate
        for (idx = 0; idx < STAGES; idx = idx + 1) begin : ADD_STAGE
            assign {carry_out_comb[idx], sum_comb[idx]} =
                adda_stage[idx] + addb_stage[idx] + carry_in_stage[idx];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and outputs
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_stage[i]    <= {STG_WIDTH{1'b0}};
                addb_stage[i]    <= {STG_WIDTH{1'b0}};
                sum_stage[i]     <= {STG_WIDTH{1'b0}};
                carry_in_stage[i] <= 1'b0;
                en_stage[i]      <= 1'b0;
            end
            carry_in_stage[STAGES] <= 1'b0;
            en_stage[STAGES]       <= 1'b0;
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en   <= 1'b0;
        end else begin
            // Stage 0 input registers and initial carry_in = 0
            adda_stage[0]    <= adda[STG_WIDTH-1:0];
            addb_stage[0]    <= addb[STG_WIDTH-1:0];
            carry_in_stage[0] <= 1'b0;
            en_stage[0]      <= i_en;

            // Subsequent stages registers inputs, carry_in, and enable
            for (i = 1; i < STAGES; i = i + 1) begin
                adda_stage[i]     <= adda[STG_WIDTH*(i+1)-1:STG_WIDTH*i];
                addb_stage[i]     <= addb[STG_WIDTH*(i+1)-1:STG_WIDTH*i];
                carry_in_stage[i] <= carry_out_comb[i-1];
                en_stage[i]       <= en_stage[i-1];
            end

            // Register sums after combinational addition
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_stage[i] <= sum_comb[i];
            end

            // Register final carry-out
            carry_in_stage[STAGES] <= carry_out_comb[STAGES-1];
            en_stage[STAGES]       <= en_stage[STAGES-1];

            // Output registers
            o_en <= en_stage[STAGES];

            if (en_stage[STAGES]) begin
                result <= {carry_in_stage[STAGES],
                           sum_stage[STAGES-1],
                           sum_stage[STAGES-2],
                           sum_stage[STAGES-3],
                           sum_stage[0]}; 
                // But indexing [STAGES-3] to 1 not handled yet, fix below
            end else begin
                result <= {(DATA_WIDTH+1){1'b0}};
            end
        end
    end

    // Assemble result from sum_stage vector correctly
    // The code above is incomplete for the concatenation. Let's fix it by a function or inline.

    // Create a wire vector to hold concatenation of sum stages
    wire [DATA_WIDTH-1:0] sum_concat;
    assign sum_concat = {sum_stage[STAGES-1],
                         sum_stage[STAGES-2],
                         sum_stage[STAGES-3],
                         sum_stage[0]};

    // The above assumes STAGES=4, explicitly indexing each slice
    // We must either unroll or build a generate concatenation for generality

    // Correct concatenation using a function for general STAGES count
    function [DATA_WIDTH-1:0] concat_sums;
        input integer stages_num;
        integer j;
        begin
            concat_sums = {DATA_WIDTH{1'b0}};
            for (j = 0; j < stages_num; j = j + 1) begin
                concat_sums = {concat_sums[DATA_WIDTH-1-STG_WIDTH:0], sum_stage[j]};
            end
        end
    endfunction

    // Using the function inside always block is illegal; so implement concat combinationally outside and register it

    // Create a wire for concatenated sum (from stage 0 LSB to stage STAGES-1 MSB)
    reg [DATA_WIDTH-1:0] sum_concat_reg;

    always @(*) begin
        sum_concat_reg = {DATA_WIDTH{1'b0}};
        for (i=0; i<STAGES; i=i+1) begin
            sum_concat_reg = (sum_concat_reg << STG_WIDTH) | sum_stage[i];
        end
    end

    // Update result register assignment to use sum_concat_reg
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= {(DATA_WIDTH+1){1'b0}};
        end else begin
            if (en_stage[STAGES]) begin
                result <= {carry_in_stage[STAGES], sum_concat_reg};
            end else begin
                result <= {(DATA_WIDTH+1){1'b0}};
            end
        end
    end

endmodule