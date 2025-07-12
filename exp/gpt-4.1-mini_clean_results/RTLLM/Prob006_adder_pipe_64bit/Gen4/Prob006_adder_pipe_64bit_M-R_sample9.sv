module adder_pipe_64bit (
    input             clk,
    input             rst_n,
    input             i_en,
    input      [63:0] adda,
    input      [63:0] addb,
    output reg [64:0] result,
    output reg        o_en
);

    localparam STAGES = 4;
    localparam WIDTH  = 16;

    // Pipeline registers for inputs
    reg [WIDTH-1:0] adda_pipe [0:STAGES-1];
    reg [WIDTH-1:0] addb_pipe [0:STAGES-1];
    reg carry_pipe [0:STAGES];      // carry chain: carry_pipe[0] = 0
    reg i_en_pipe [0:STAGES];

    // Sum wires - combinational results of addition at each stage
    wire [WIDTH:0] sum_carry [0:STAGES-1];

    integer i;

    // Combinational addition for each stage
    generate
        genvar idx;
        for (idx = 0; idx < STAGES; idx = idx + 1) begin : add_stage
            assign sum_carry[idx] = {1'b0, adda_pipe[idx]} + {1'b0, addb_pipe[idx]} + carry_pipe[idx];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset pipeline registers
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= {WIDTH{1'b0}};
                addb_pipe[i] <= {WIDTH{1'b0}};
                carry_pipe[i] <= 1'b0;
                i_en_pipe[i] <= 1'b0;
            end
            carry_pipe[STAGES] <= 1'b0;
            i_en_pipe[STAGES] <= 1'b0;
            result <= 65'b0;
            o_en <= 1'b0;
        end else begin
            // Stage 0 inputs and initial carry zero
            adda_pipe[0] <= adda[WIDTH-1:0];
            addb_pipe[0] <= addb[WIDTH-1:0];
            carry_pipe[0] <= 1'b0;
            i_en_pipe[0] <= i_en;

            // Pipeline subsequent stages and carry propagation
            for (i = 1; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= adda[i*WIDTH +: WIDTH];
                addb_pipe[i] <= addb[i*WIDTH +: WIDTH];
                carry_pipe[i] <= sum_carry[i-1][WIDTH];
                i_en_pipe[i] <= i_en_pipe[i-1];
            end

            // Final carry registration
            carry_pipe[STAGES] <= sum_carry[STAGES-1][WIDTH];
            i_en_pipe[STAGES] <= i_en_pipe[STAGES-1];

            // Assemble result from all stage sums and final carry
            result <= {
                carry_pipe[STAGES],
                sum_carry[STAGES-1][WIDTH-1:0],
                sum_carry[STAGES-2][WIDTH-1:0],
                sum_carry[STAGES-3][WIDTH-1:0],
                sum_carry[0][WIDTH-1:0]
            };

            // Output enable propagated through pipeline
            o_en <= i_en_pipe[STAGES];
        end
    end

endmodule