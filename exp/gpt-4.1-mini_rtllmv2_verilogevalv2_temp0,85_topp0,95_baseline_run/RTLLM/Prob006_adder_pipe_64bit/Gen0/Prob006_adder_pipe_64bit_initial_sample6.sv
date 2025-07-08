module adder_pipe_64bit (
    input             clk,
    input             rst_n,
    input             i_en,
    input      [63:0] adda,
    input      [63:0] addb,
    output reg [64:0] result,
    output reg        o_en
);

// Parameters
localparam STAGES = 8;
localparam SEG_WIDTH = 8;

// Pipeline registers
reg [SEG_WIDTH-1:0] sum_pipe [0:STAGES-1];    // partial sums per stage
reg carry_pipe [0:STAGES-1];                   // carry bits per stage
reg en_pipe [0:STAGES];                        // enable pipeline

// Internal wires for stage inputs
wire [SEG_WIDTH-1:0] adda_seg [0:STAGES-1];
wire [SEG_WIDTH-1:0] addb_seg [0:STAGES-1];

// Assign segments from inputs
genvar i;
generate
    for (i=0; i<STAGES; i=i+1) begin : seg_assign
        assign adda_seg[i] = adda[i*SEG_WIDTH +: SEG_WIDTH];
        assign addb_seg[i] = addb[i*SEG_WIDTH +: SEG_WIDTH];
    end
endgenerate

integer j;

// Pipeline and addition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers and enable signals
        for (j=0; j<STAGES; j=j+1) begin
            sum_pipe[j] <= 0;
            carry_pipe[j] <= 0;
            en_pipe[j] <= 0;
        end
        en_pipe[STAGES] <= 0;
        result <= 0;
        o_en <= 0;
    end else begin
        // Shift enable pipeline
        en_pipe[0] <= i_en;
        for (j=1; j<=STAGES; j=j+1)
            en_pipe[j] <= en_pipe[j-1];
        
        // Stage 0 addition: carry in = 0
        {carry_pipe[0], sum_pipe[0]} <= adda_seg[0] + addb_seg[0];
        
        // Subsequent stages addition with carry in from previous stage
        for (j=1; j<STAGES; j=j+1) begin
            {carry_pipe[j], sum_pipe[j]} <= adda_seg[j] + addb_seg[j] + carry_pipe[j-1];
        end

        // Output assignment when last stage is valid
        if (en_pipe[STAGES]) begin
            // Concatenate sums and final carry out
            result <= {carry_pipe[STAGES-1],
                       sum_pipe[STAGES-1],
                       sum_pipe[STAGES-2],
                       sum_pipe[STAGES-3],
                       sum_pipe[STAGES-4],
                       sum_pipe[STAGES-5],
                       sum_pipe[STAGES-6],
                       sum_pipe[STAGES-7],
                       sum_pipe[0]}; 
            // The order above is MSB sum segment first down to LSB sum segment last.
            // The first sum_pipe[0] is LSB segment, last sum_pipe[STAGES-1] is MSB segment
            // So reverse the order in concatenation:
            // Correct order: from MSB to LSB:
            // carry_pipe[7], sum_pipe[7], sum_pipe[6], ..., sum_pipe[0]
            // which matches the code above.
            o_en <= 1'b1;
        end else begin
            result <= result;
            o_en <= 1'b0;
        end
    end
end

endmodule