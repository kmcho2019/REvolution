module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter STG_WIDTH = DATA_WIDTH
)(
    input                   clk,
    input                   rst_n,
    input                   i_en,
    input   [DATA_WIDTH-1:0] adda,
    input   [DATA_WIDTH-1:0] addb,
    output reg  [DATA_WIDTH:0] result,
    output reg              o_en
);

    // Registered inputs to hold stable operands during pipeline traversal
    reg [DATA_WIDTH-1:0] adda_reg;
    reg [DATA_WIDTH-1:0] addb_reg;

    // Carry pipeline: carry_in to bit i addition stored at bit i of this vector
    // carry_pipeline[0] is carry-in for bit 0, carry_pipeline[STG_WIDTH] is final carry out
    reg [STG_WIDTH:0] carry_pipeline;

    // Sum pipeline bits for all DATA_WIDTH bits
    reg [STG_WIDTH-1:0] sum_pipeline;

    // Enable pipeline shift register for input enable tracking
    reg [STG_WIDTH-1:0] en_pipeline;

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            adda_reg <= {DATA_WIDTH{1'b0}};
            addb_reg <= {DATA_WIDTH{1'b0}};
            carry_pipeline <= {(STG_WIDTH+1){1'b0}};
            sum_pipeline <= {STG_WIDTH{1'b0}};
            en_pipeline <= {STG_WIDTH{1'b0}};
            result <= {(DATA_WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Shift enable pipeline, new enable bit at LSB
            en_pipeline <= {en_pipeline[STG_WIDTH-2:0], i_en};

            // Capture inputs and initialize carry_pipeline[0] on valid input
            if (i_en) begin
                adda_reg <= adda;
                addb_reg <= addb;
                carry_pipeline[0] <= 1'b0;  // Initial carry-in is zero per addition
            end else begin
                carry_pipeline[0] <= carry_pipeline[0]; // Hold stable
            end

            // Pipeline the carry and sum for each bit stage
            // For each bit i, sum = a[i] xor b[i] xor carry_in[i]
            // Carry_out = majority(a[i], b[i], carry_in[i])
            for (i = 0; i < STG_WIDTH; i = i + 1) begin
                if (en_pipeline[i] || i_en) begin
                    sum_pipeline[i] <= adda_reg[i] ^ addb_reg[i] ^ carry_pipeline[i];
                    carry_pipeline[i+1] <= (adda_reg[i] & addb_reg[i]) |
                                           (adda_reg[i] & carry_pipeline[i]) |
                                           (addb_reg[i] & carry_pipeline[i]);
                end else begin
                    sum_pipeline[i] <= 1'b0;
                    carry_pipeline[i+1] <= 1'b0;
                end
            end

            // Output enable is the last bit of the enable pipeline
            o_en <= en_pipeline[STG_WIDTH-1];

            // When output enabled, assemble full sum: carry out + sum bits
            if (en_pipeline[STG_WIDTH-1]) begin
                result <= {carry_pipeline[STG_WIDTH], sum_pipeline};
            end else begin
                result <= {(DATA_WIDTH+1){1'b0}};
            end
        end
    end

endmodule