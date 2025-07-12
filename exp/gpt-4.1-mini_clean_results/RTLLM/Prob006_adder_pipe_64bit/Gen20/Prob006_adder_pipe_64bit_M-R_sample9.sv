module adder_pipe_64bit #(
    parameter WIDTH = 64,
    parameter STAGES = 4,
    parameter STAGE_WIDTH = WIDTH / STAGES
)(
    input                   clk,
    input                   rst_n,
    input                   i_en,
    input      [WIDTH-1:0]  adda,
    input      [WIDTH-1:0]  addb,
    output reg [WIDTH:0]    result,
    output reg              o_en
);

    // Register input operands and input enable at first pipeline stage
    reg [WIDTH-1:0] adda_reg;
    reg [WIDTH-1:0] addb_reg;
    reg             en_reg;

    // Carry and enable pipeline registers for each stage
    reg [STAGES:0] carry_pipe;    // carry_pipe[0] always 0 (initial carry in)
    reg [STAGES:0] en_pipe;       // enable signal pipeline

    // Slices of the registered operands for each stage
    wire [STAGE_WIDTH-1:0] a_slice [0:STAGES-1];
    wire [STAGE_WIDTH-1:0] b_slice [0:STAGES-1];

    genvar i;
    generate
        for (i = 0; i < STAGES; i = i + 1) begin : gen_slices
            assign a_slice[i] = adda_reg[i*STAGE_WIDTH +: STAGE_WIDTH];
            assign b_slice[i] = addb_reg[i*STAGE_WIDTH +: STAGE_WIDTH];
        end
    endgenerate

    // Compute partial sums and carry-out combinationally for each stage
    wire [STAGE_WIDTH:0] sum_stage [0:STAGES-1]; // [STAGE_WIDTH-1:0] sum, [STAGE_WIDTH] carry_out

    generate
        for (i = 0; i < STAGES; i = i + 1) begin : gen_adders
            assign sum_stage[i] = a_slice[i] + b_slice[i] + carry_pipe[i];
        end
    endgenerate

    integer idx;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and output
            adda_reg <= {WIDTH{1'b0}};
            addb_reg <= {WIDTH{1'b0}};
            en_reg <= 1'b0;

            carry_pipe <= {(STAGES+1){1'b0}};
            en_pipe <= {(STAGES+1){1'b0}};

            result <= {(WIDTH+1){1'b0}};
            o_en <= 1'b0;
        end else begin
            // Register inputs and initial enable
            adda_reg <= adda;
            addb_reg <= addb;
            en_reg <= i_en;

            // Update enable pipeline signals
            en_pipe[0] <= en_reg;
            for (idx = 1; idx <= STAGES; idx = idx + 1) begin
                en_pipe[idx] <= en_pipe[idx - 1];
            end

            // Update carry pipeline signals
            carry_pipe[0] <= 1'b0; // initial carry in zero
            for (idx = 0; idx < STAGES; idx = idx + 1) begin
                carry_pipe[idx + 1] <= sum_stage[idx][STAGE_WIDTH]; // carry out from stage idx
            end

            // When final stage enable is asserted, output concatenated sum and carry
            if (en_pipe[STAGES]) begin
                // Concatenate partial sums in order from LSB stage (0) to MSB stage (STAGES-1)
                // Using a procedural loop to build the vector before assigning result
                reg [WIDTH-1:0] sum_concat;
                sum_concat = {WIDTH{1'b0}};
                for (idx = 0; idx < STAGES; idx = idx + 1) begin
                    sum_concat[idx*STAGE_WIDTH +: STAGE_WIDTH] = sum_stage[idx][STAGE_WIDTH-1:0];
                end
                result <= {carry_pipe[STAGES], sum_concat};
                o_en <= 1'b1;
            end else begin
                result <= {(WIDTH+1){1'b0}};
                o_en <= 1'b0;
            end
        end
    end

endmodule