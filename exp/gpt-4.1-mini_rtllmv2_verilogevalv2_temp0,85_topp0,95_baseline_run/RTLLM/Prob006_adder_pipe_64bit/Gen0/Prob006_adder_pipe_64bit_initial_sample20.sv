module adder_pipe_64bit (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         i_en,
    input  wire [63:0]  adda,
    input  wire [63:0]  addb,
    output reg  [64:0]  result,
    output reg          o_en
);

// Parameters for pipeline stages
localparam STAGES = 8;
localparam WIDTH = 8; // bits per stage

// Pipeline registers for inputs
reg [63:0] adda_pipe [0:STAGES];
reg [63:0] addb_pipe [0:STAGES];
reg        en_pipe   [0:STAGES];

// Pipeline registers for carry signals between stages
reg [STAGES:0] carry_pipe; // carry_pipe[0] is carry-in to stage 0, always 0

// Pipeline registers for sum segments
reg [WIDTH-1:0] sum_pipe [0:STAGES-1];

// Initialize carry-in to zero at first pipeline stage
wire carry_in_stage0 = 1'b0;

// At each pipeline stage, add 8 bits plus carry-in from previous stage
integer i;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers and outputs
        for (i = 0; i <= STAGES; i = i + 1) begin
            adda_pipe[i] <= 64'b0;
            addb_pipe[i] <= 64'b0;
            en_pipe[i]   <= 1'b0;
            carry_pipe[i] <= 1'b0;
        end
        for (i = 0; i < STAGES; i = i + 1) begin
            sum_pipe[i] <= {WIDTH{1'b0}};
        end
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Pipeline input operands and enable
        adda_pipe[0] <= adda;
        addb_pipe[0] <= addb;
        en_pipe[0]   <= i_en;

        // Pipeline carry_in for stage 0 is zero
        carry_pipe[0] <= 1'b0;

        // At stage 0, compute sum and carry-out
        // Do addition of 8 bits + carry_in
        {carry_pipe[1], sum_pipe[0]} <= adda_pipe[0][7:0] + addb_pipe[0][7:0] + carry_pipe[0];
        // Pipeline inputs for next stage
        adda_pipe[1] <= adda_pipe[0];
        addb_pipe[1] <= addb_pipe[0];
        en_pipe[1]   <= en_pipe[0];

        // For stages 1 to STAGES-1, repeat the pipelined addition
        for (i = 1; i < STAGES; i = i + 1) begin
            // carry_pipe[i] is carry-in for stage i
            {carry_pipe[i+1], sum_pipe[i]} <= adda_pipe[i][(i+1)*WIDTH-1 -: WIDTH] + addb_pipe[i][(i+1)*WIDTH-1 -: WIDTH] + carry_pipe[i];
            // Pipeline inputs to next stage
            adda_pipe[i+1] <= adda_pipe[i];
            addb_pipe[i+1] <= addb_pipe[i];
            en_pipe[i+1]   <= en_pipe[i];
        end

        // After last stage, output the final result and enable
        // Concatenate all sum segments plus final carry out
        result <= {
            carry_pipe[STAGES],
            sum_pipe[STAGES-1],
            sum_pipe[STAGES-2],
            sum_pipe[STAGES-3],
            sum_pipe[STAGES-4],
            sum_pipe[STAGES-5],
            sum_pipe[STAGES-6],
            sum_pipe[STAGES-7],
            sum_pipe[STAGES-8]
        };
        // The sum_pipe array indices 0 to STAGES-1 correspond to stages 0..7
        // But we have 8 stages, so indexes 0..7, sum_pipe[7] is last
        // To avoid confusion, reorder sum_pipe[0] to sum_pipe[7] LSB to MSB:
        // We can construct the sum by concatenating sum_pipe[7] as MSB down to sum_pipe[0] as LSB

        // Let's fix this output assignment with a generate block instead:

        // Update o_en delayed to last pipeline stage
        o_en <= en_pipe[STAGES];
    end
end

// Since Verilog does not allow dynamic concatenation in always block easily, 
// We can assign result combinationally from sum_pipe registers

wire [64:0] result_comb;
assign result_comb = {
    carry_pipe[STAGES],
    sum_pipe[7],
    sum_pipe[6],
    sum_pipe[5],
    sum_pipe[4],
    sum_pipe[3],
    sum_pipe[2],
    sum_pipe[1],
    sum_pipe[0]
};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'b0;
    end else begin
        result <= result_comb;
    end
end

endmodule