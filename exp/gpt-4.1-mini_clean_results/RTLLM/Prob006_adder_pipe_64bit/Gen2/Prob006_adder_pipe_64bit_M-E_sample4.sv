module adder_pipe_64bit (
    input              clk,
    input              rst_n,
    input              i_en,
    input      [63:0]  adda,
    input      [63:0]  addb,
    output reg [64:0]  result,
    output reg         o_en
);

    localparam STAGES = 8;
    localparam WIDTH  = 8;

    // Pipeline registers for operand slices per stage
    reg [WIDTH-1:0] adda_pipe [0:STAGES-1];
    reg [WIDTH-1:0] addb_pipe [0:STAGES-1];
    reg             i_en_pipe [0:STAGES];

    // Carry registers between stages
    reg carry_pipe [0:STAGES]; // carry_pipe[0] is initial carry-in (zero)

    // Sum registers per stage
    reg [WIDTH-1:0] sum_pipe [0:STAGES-1];

    integer i;

    // Wires for combinational adds per stage
    wire [WIDTH:0] add_result [0:STAGES-1];

    // Combinational addition for each stage
    generate
        genvar idx;
        for (idx = 0; idx < STAGES; idx = idx + 1) begin : adder_stage
            assign add_result[idx] = {1'b0, adda_pipe[idx]} + {1'b0, addb_pipe[idx]} + carry_pipe[idx];
        end
    endgenerate

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers and outputs
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= {WIDTH{1'b0}};
                addb_pipe[i] <= {WIDTH{1'b0}};
                sum_pipe[i]  <= {WIDTH{1'b0}};
                i_en_pipe[i] <= 1'b0;
                carry_pipe[i] <= 1'b0;
            end
            carry_pipe[STAGES] <= 1'b0;
            i_en_pipe[STAGES] <= 1'b0;
            result <= {65{1'b0}};
            o_en <= 1'b0;
        end else begin
            // Stage 0 input registration
            adda_pipe[0] <= adda[ 7: 0];
            addb_pipe[0] <= addb[ 7: 0];
            i_en_pipe[0] <= i_en;
            carry_pipe[0] <= 1'b0; // initial carry-in zero

            // Pipeline registration for operands and enables for stages 1..STAGES-1
            for (i = 1; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= adda[ (i*WIDTH)+:WIDTH ];
                addb_pipe[i] <= addb[ (i*WIDTH)+:WIDTH ];
                i_en_pipe[i] <= i_en_pipe[i-1];
            end

            // Register sums and carry_out for each stage
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= add_result[i][WIDTH-1:0];
                carry_pipe[i+1] <= add_result[i][WIDTH];
            end

            // Propagate output enable signal through last stage
            i_en_pipe[STAGES] <= i_en_pipe[STAGES-1];

            // Assemble output result from all sums and last carry
            result <= {carry_pipe[STAGES], 
                       sum_pipe[7], sum_pipe[6], sum_pipe[5], sum_pipe[4],
                       sum_pipe[3], sum_pipe[2], sum_pipe[1], sum_pipe[0]};
            o_en <= i_en_pipe[STAGES];
        end
    end

endmodule