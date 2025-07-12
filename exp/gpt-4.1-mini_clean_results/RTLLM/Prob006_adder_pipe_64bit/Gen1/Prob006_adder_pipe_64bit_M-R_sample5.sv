module adder_pipe_64bit (
    input              clk,
    input              rst_n,
    input              i_en,
    input      [63:0]  adda,
    input      [63:0]  addb,
    output reg [64:0]  result,
    output reg         o_en
);

    localparam STAGES = 4;
    localparam WIDTH  = 16;

    // Pipeline registers for operands segments
    reg [63:0] adda_pipe [0:STAGES-1];
    reg [63:0] addb_pipe [0:STAGES-1];
    reg        i_en_pipe [0:STAGES];

    // Carry registers between stages
    reg [STAGES:0] carry_pipe;

    // Sum registers per stage
    reg [WIDTH-1:0] sum_pipe [0:STAGES-1];

    integer i;

    // Wires for combinational add results per stage
    wire [WIDTH:0] add_result [0:STAGES-1];

    // Combinational addition for each stage using current stage operands and carry in
    assign add_result[0] = {1'b0, adda_pipe[0][ 15:  0]} + {1'b0, addb_pipe[0][ 15:  0]} + carry_pipe[0];
    assign add_result[1] = {1'b0, adda_pipe[1][ 31: 16]} + {1'b0, addb_pipe[1][ 31: 16]} + carry_pipe[1];
    assign add_result[2] = {1'b0, adda_pipe[2][ 47: 32]} + {1'b0, addb_pipe[2][ 47: 32]} + carry_pipe[2];
    assign add_result[3] = {1'b0, adda_pipe[3][ 63: 48]} + {1'b0, addb_pipe[3][ 63: 48]} + carry_pipe[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= 64'd0;
                addb_pipe[i] <= 64'd0;
                sum_pipe[i]  <= {WIDTH{1'b0}};
            end
            for (i = 0; i <= STAGES; i = i + 1) begin
                carry_pipe[i] <= 1'b0;
            end
            for (i = 0; i <= STAGES; i = i + 1) begin
                if(i < STAGES)
                    i_en_pipe[i] <= 1'b0;
                else
                    o_en <= 1'b0;
            end
            result <= 65'd0;
        end else begin
            // Stage 0 input registers
            adda_pipe[0] <= adda;
            addb_pipe[0] <= addb;
            i_en_pipe[0] <= i_en;
            carry_pipe[0] <= 1'b0; // initial carry-in zero

            // Pipeline registers for operands and i_en
            for (i = 1; i < STAGES; i = i + 1) begin
                adda_pipe[i] <= adda_pipe[i-1];
                addb_pipe[i] <= addb_pipe[i-1];
                i_en_pipe[i] <= i_en_pipe[i-1];
            end

            // Register sums and carry_outs from combinational add
            for (i = 0; i < STAGES; i = i + 1) begin
                sum_pipe[i] <= add_result[i][WIDTH-1:0];
                carry_pipe[i+1] <= add_result[i][WIDTH];
            end

            // Propagate output enable through last stage
            i_en_pipe[STAGES] <= i_en_pipe[STAGES-1];

            // Output assignment when last stage is valid
            result <= {carry_pipe[STAGES], 
                       sum_pipe[3], 
                       sum_pipe[2], 
                       sum_pipe[1], 
                       sum_pipe[0]};
            o_en <= i_en_pipe[STAGES];
        end
    end

endmodule