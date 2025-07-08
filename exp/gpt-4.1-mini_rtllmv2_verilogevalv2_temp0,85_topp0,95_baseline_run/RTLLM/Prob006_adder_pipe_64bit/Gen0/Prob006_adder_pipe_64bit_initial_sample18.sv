module adder_pipe_64bit (
    input           clk,
    input           rst_n,
    input           i_en,
    input  [63:0]   adda,
    input  [63:0]   addb,
    output reg [64:0] result,
    output reg      o_en
);

// Pipeline parameters
localparam STAGES = 4;
localparam WIDTH = 16;

// Registers to hold pipeline intermediate sums and carry outs
reg [WIDTH-1:0] stage_adda   [0:STAGES-1];
reg [WIDTH-1:0] stage_addb   [0:STAGES-1];
reg             stage_cin    [0:STAGES-1]; // carry-in for each stage
reg             stage_cout   [0:STAGES-1]; // carry-out for each stage
reg [WIDTH-1:0] stage_sum    [0:STAGES-1];

reg [STAGES:0]  en_pipe; // enable pipeline signals (STAGES+1 length to delay through all stages)

// Break inputs into 16-bit chunks and register at stage 0
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        en_pipe <= 0;
        // Clear pipeline registers
        integer i;
        for (i=0; i<STAGES; i=i+1) begin
            stage_adda[i] <= 0;
            stage_addb[i] <= 0;
            stage_cin[i] <= 0;
            stage_sum[i] <= 0;
            stage_cout[i] <= 0;
        end
        result <= 0;
        o_en <= 0;
    end else begin
        // Shift enable pipeline
        en_pipe <= {en_pipe[STAGES-1:0], i_en};

        // Stage 0 inputs registered
        if (i_en) begin
            stage_adda[0] <= adda[15:0];
            stage_addb[0] <= addb[15:0];
            stage_cin[0]  <= 1'b0;  // initial carry-in is 0
        end

        // Compute stage 0 sum and carry
        {stage_cout[0], stage_sum[0]} <= stage_adda[0] + stage_addb[0] + stage_cin[0];

        // Stages 1 to STAGES-1
        integer s;
        for (s=1; s<STAGES; s=s+1) begin
            // Register inputs from previous stage
            if (en_pipe[s-1]) begin
                stage_adda[s] <= adda[s*WIDTH +: WIDTH];
                stage_addb[s] <= addb[s*WIDTH +: WIDTH];
                stage_cin[s]  <= stage_cout[s-1];
            end

            // Compute sum and carry for this stage
            {stage_cout[s], stage_sum[s]} <= stage_adda[s] + stage_addb[s] + stage_cin[s];
        end

        // When the last stage's output is ready, form the full result and output enable
        if (en_pipe[STAGES-1]) begin
            result <= {stage_cout[STAGES-1],
                       stage_sum[STAGES-1],
                       stage_sum[STAGES-2],
                       stage_sum[STAGES-3],
                       stage_sum[0]};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule