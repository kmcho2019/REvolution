module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 16
)(
    input  wire                   clk,
    input  wire                   rst_n,
    input  wire                   i_en,
    input  wire [DATA_WIDTH-1:0] adda,
    input  wire [DATA_WIDTH-1:0] addb,
    output reg  [DATA_WIDTH:0]   result,
    output reg                   o_en
);

    // Number of pipeline stages
    localparam NUM_STAGES = DATA_WIDTH / STG_WIDTH;

    // Stage input registers
    reg [STG_WIDTH-1:0] adda_reg [0:NUM_STAGES-1];
    reg [STG_WIDTH-1:0] addb_reg [0:NUM_STAGES-1];

    // Sum registers
    reg [STG_WIDTH-1:0] sum_reg [0:NUM_STAGES-1];

    // Carry registers: carry between stages (carry[0] is carry-in to stage 0)
    reg carry [0:NUM_STAGES];

    // Pipeline shift register for enable signal, length = NUM_STAGES + 1
    reg [NUM_STAGES:0] en_pipe;

    integer i;

    // Slices of adda and addb inputs for each stage
    wire [STG_WIDTH-1:0] adda_slices [0:NUM_STAGES-1];
    wire [STG_WIDTH-1:0] addb_slices [0:NUM_STAGES-1];

    genvar idx;
    generate
        for (idx = 0; idx < NUM_STAGES; idx = idx + 1) begin : slice_inputs
            assign adda_slices[idx] = adda[STG_WIDTH*idx +: STG_WIDTH];
            assign addb_slices[idx] = addb[STG_WIDTH*idx +: STG_WIDTH];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and carry
            for (i = 0; i < NUM_STAGES; i = i + 1) begin
                adda_reg[i] <= {STG_WIDTH{1'b0}};
                addb_reg[i] <= {STG_WIDTH{1'b0}};
                sum_reg[i]  <= {STG_WIDTH{1'b0}};
            end
            for (i = 0; i <= NUM_STAGES; i = i + 1) begin
                carry[i] <= 1'b0;
            end
            en_pipe <= {NUM_STAGES+1{1'b0}};
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Shift enable pipeline register
            en_pipe <= {en_pipe[NUM_STAGES-1:0], i_en};

            // Stage 0 input and carry-in
            if (i_en) begin
                adda_reg[0] <= adda_slices[0];
                addb_reg[0] <= addb_slices[0];
                carry[0]    <= 1'b0; // no carry-in at first stage
            end

            // Stage 0 sum and carry-out
            {carry[1], sum_reg[0]} <= adda_reg[0] + addb_reg[0] + carry[0];

            // Subsequent stages
            for (i = 1; i < NUM_STAGES; i = i + 1) begin
                if (en_pipe[i]) begin
                    adda_reg[i] <= adda_slices[i];
                    addb_reg[i] <= addb_slices[i];
                end
                {carry[i+1], sum_reg[i]} <= adda_reg[i] + addb_reg[i] + carry[i];
            end

            // Output assembly and output enable
            if (en_pipe[NUM_STAGES]) begin
                // Concatenate sums from MSB stage to LSB, with carry-out as MSB
                // Result width = DATA_WIDTH + 1
                result <= {carry[NUM_STAGES], 
                           sum_reg[NUM_STAGES-1], 
                           sum_reg[NUM_STAGES-2], 
                           sum_reg[NUM_STAGES-3], 
                           sum_reg[NUM_STAGES-4]};
                // Above concatenation only works correctly for 4 stages, so need to generalize:

                // Generalized concatenation:
                // Since Verilog doesn't support concatenation of arrays directly, use a loop and an intermediate variable
            end else begin
                // Maintain previous result if no valid output
                result <= result;
            end

            o_en <= en_pipe[NUM_STAGES];
        end
    end

    // Generate final result concatenation in a separate combinational block
    // Because variable concatenation of array elements isn't supported inline easily
    reg [DATA_WIDTH-1:0] sum_concat;
    integer j;

    always @(*) begin
        sum_concat = {DATA_WIDTH{1'b0}};
        for (j = 0; j < NUM_STAGES; j = j + 1) begin
            sum_concat[STG_WIDTH*j +: STG_WIDTH] = sum_reg[j];
        end
    end

    // Update result when output enable asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= {(DATA_WIDTH+1){1'b0}};
        end else if (en_pipe[NUM_STAGES]) begin
            result <= {carry[NUM_STAGES], sum_concat};
        end
    end

endmodule