module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH  = 16
)(
    input                       clk,
    input                       rst_n,
    input                       i_en,
    input      [DATA_WIDTH-1:0] adda,
    input      [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0]   result,
    output reg                  o_en
);

    localparam NUM_STG = DATA_WIDTH / STG_WIDTH;

    // Pipeline registers for operands per stage
    reg [STG_WIDTH-1:0] adda_reg [0:NUM_STG-1];
    reg [STG_WIDTH-1:0] addb_reg [0:NUM_STG-1];

    // Pipeline registers for carry signals between stages
    reg carry_reg [0:NUM_STG];

    // Pipeline registers for valid enable signals
    reg en_reg [0:NUM_STG];

    // Combinational sums and carries per stage
    wire [STG_WIDTH-1:0] sum_comb [0:NUM_STG-1];
    wire carry_comb [0:NUM_STG-1];

    integer i;

    // Combinational addition for each stage
    generate
        genvar gi;
        for (gi = 0; gi < NUM_STG; gi = gi + 1) begin : ADD_STAGE
            assign {carry_comb[gi], sum_comb[gi]} = adda_reg[gi] + addb_reg[gi] + carry_reg[gi];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset pipeline registers
            for (i = 0; i < NUM_STG; i = i + 1) begin
                adda_reg[i]  <= {STG_WIDTH{1'b0}};
                addb_reg[i]  <= {STG_WIDTH{1'b0}};
                carry_reg[i] <= 1'b0;
                en_reg[i]    <= 1'b0;
            end
            carry_reg[NUM_STG] <= 1'b0;
            en_reg[NUM_STG]    <= 1'b0;
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Stage 0 input registers and carry-in = 0
            if (i_en) begin
                adda_reg[0] <= adda[0 +: STG_WIDTH];
                addb_reg[0] <= addb[0 +: STG_WIDTH];
            end else begin
                adda_reg[0] <= adda_reg[0];
                addb_reg[0] <= addb_reg[0];
            end
            carry_reg[0] <= 1'b0;
            en_reg[0] <= i_en;

            // For stages 1 to NUM_STG-1, register operands from input when previous stage valid
            for (i = 1; i < NUM_STG; i = i + 1) begin
                if (en_reg[i-1]) begin
                    adda_reg[i] <= adda[i*STG_WIDTH +: STG_WIDTH];
                    addb_reg[i] <= addb[i*STG_WIDTH +: STG_WIDTH];
                end else begin
                    adda_reg[i] <= adda_reg[i];
                    addb_reg[i] <= addb_reg[i];
                end
            end

            // Update carry and enable registers for stages 1 to NUM_STG
            for (i = 0; i < NUM_STG; i = i + 1) begin
                carry_reg[i+1] <= carry_comb[i];
                en_reg[i+1]    <= en_reg[i];
            end

            // Output when last stage enable is asserted
            o_en <= en_reg[NUM_STG];
            if (en_reg[NUM_STG]) begin
                // Concatenate final carry and sums in MSB-to-LSB order
                result <= {carry_reg[NUM_STG],
                           sum_comb[NUM_STG-1],
                           sum_comb[NUM_STG-2],
                           sum_comb[NUM_STG-3],
                           sum_comb[0]};
                // For general NUM_STG, build concatenation dynamically:
                // but since Verilog does not allow variable concatenation easily,
                // here we build by generate block below for general case.
            end else begin
                result <= result;
            end
        end
    end

    // To support general NUM_STG concatenation for result:
    // Create intermediate wire to hold sums concatenated in order from MSB stage to LSB stage

    wire [DATA_WIDTH-1:0] sums_concat;
    generate
        genvar j;
        for (j = 0; j < NUM_STG; j = j + 1) begin : CONCAT_SUMS
            assign sums_concat[(DATA_WIDTH - 1) - j*STG_WIDTH -: STG_WIDTH] = sum_comb[NUM_STG - 1 - j];
        end
    endgenerate

    // Assign final result bits when output enable is asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= {(DATA_WIDTH+1){1'b0}};
        end else if (en_reg[NUM_STG]) begin
            result <= {carry_reg[NUM_STG], sums_concat};
        end
    end

endmodule