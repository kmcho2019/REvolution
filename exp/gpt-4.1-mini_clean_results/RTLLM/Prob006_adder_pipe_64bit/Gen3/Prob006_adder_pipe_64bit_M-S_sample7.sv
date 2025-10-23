module adder_pipe_64bit (
    input           clk,
    input           rst_n,
    input           i_en,
    input  [63:0]   adda,
    input  [63:0]   addb,
    output reg [64:0] result,
    output reg      o_en
);

    localparam STAGES = 4;
    localparam WIDTH = 16;

    // Pipeline registers for input operands per stage
    reg [WIDTH-1:0] adda_pipe [0:STAGES-1];
    reg [WIDTH-1:0] addb_pipe [0:STAGES-1];

    // Carry pipeline, carry_pipe[0] is initial carry-in (0)
    reg carry_pipe [0:STAGES];

    // Sum pipeline registers
    reg [WIDTH-1:0] sum_pipe [0:STAGES-1];

    // Pipeline register for enable signal
    reg [STAGES-1:0] en_pipe;

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            carry_pipe[0] <= 1'b0;
            o_en <= 1'b0;
            result <= 0;
            en_pipe <= 0;

            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= 0;
                addb_pipe[i] <= 0;
                sum_pipe[i] <= 0;
                carry_pipe[i+1] <= 0;
            end
        end else begin
            // Pipeline input enable
            en_pipe <= {en_pipe[STAGES-2:0], i_en};

            // Stage 0 inputs latched when i_en is high
            if (i_en) begin
                adda_pipe[0] <= adda[WIDTH-1:0];
                addb_pipe[0] <= addb[WIDTH-1:0];
            end else begin
                adda_pipe[0] <= 0;
                addb_pipe[0] <= 0;
            end
            carry_pipe[0] <= 1'b0; // initial carry-in zero

            // For stages 1..STAGES-1, latch inputs from corresponding adda/addb slices if previous stage enable high
            for (i = 1; i < STAGES; i = i + 1) begin
                if (en_pipe[i-1]) begin
                    adda_pipe[i] <= adda[(i+1)*WIDTH-1 : i*WIDTH];
                    addb_pipe[i] <= addb[(i+1)*WIDTH-1 : i*WIDTH];
                end else begin
                    adda_pipe[i] <= 0;
                    addb_pipe[i] <= 0;
                end
            end

            // Compute sums and carries per stage if valid enable
            for (i = 0; i < STAGES; i = i + 1) begin
                if ( (i == 0 && i_en) || (i > 0 && en_pipe[i-1]) ) begin
                    {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i] + addb_pipe[i] + carry_pipe[i];
                end else begin
                    sum_pipe[i] <= 0;
                    carry_pipe[i+1] <= 0;
                end
            end

            // Output enable delayed by STAGES cycles
            o_en <= en_pipe[STAGES-1];

            if (en_pipe[STAGES-1]) begin
                // Concatenate sum pieces and final carry for full 65-bit result
                result <= {carry_pipe[STAGES],
                           sum_pipe[STAGES-1],
                           sum_pipe[STAGES-2],
                           sum_pipe[STAGES-3],
                           sum_pipe[STAGES-4]};
            end else begin
                result <= 0;
            end
        end
    end

endmodule