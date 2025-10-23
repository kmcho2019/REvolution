module adder_pipe_64bit #(
    parameter DATA_WIDTH = 64,
    parameter SEG_WIDTH = 8
) (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [DATA_WIDTH-1:0] adda,
    input wire [DATA_WIDTH-1:0] addb,
    output reg [DATA_WIDTH:0] result,
    output reg o_en
);

// Parameter validation
initial begin
    if (DATA_WIDTH % SEG_WIDTH != 0) begin
        $error("Error: DATA_WIDTH must be divisible by SEG_WIDTH");
        $finish;
    end
end

localparam NUM_SEG = DATA_WIDTH / SEG_WIDTH;
localparam PIPELINE_DEPTH = NUM_SEG;

// Pipeline registers
reg [SEG_WIDTH-1:0] a_seg [0:NUM_SEG-1];
reg [SEG_WIDTH-1:0] b_seg [0:NUM_SEG-1];
reg [SEG_WIDTH:0] sum_seg [0:NUM_SEG-1]; // Includes carry bit
reg [NUM_SEG:0] carry_pipe [0:PIPELINE_DEPTH-1];
reg [PIPELINE_DEPTH:0] en_pipe = '0;

// Pipeline processing
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        for (int i = 0; i < NUM_SEG; i = i + 1) begin
            a_seg[i] <= '0;
            b_seg[i] <= '0;
            sum_seg[i] <= '0;
        end
        for (int i = 0; i < PIPELINE_DEPTH; i = i + 1) begin
            carry_pipe[i] <= '0;
        end
        en_pipe <= '0;
        result <= '0;
        o_en <= 1'b0;
    end else begin
        // Shift enable through pipeline
        en_pipe <= {en_pipe[PIPELINE_DEPTH-1:0], i_en};
        
        // First stage processing
        if (i_en) begin
            // Input stage
            a_seg[0] <= adda[SEG_WIDTH-1:0];
            b_seg[0] <= addb[SEG_WIDTH-1:0];
            {carry_pipe[0][1], sum_seg[0]} <= adda[SEG_WIDTH-1:0] + addb[SEG_WIDTH-1:0];
            carry_pipe[0][0] <= 1'b0;
            
            // Store remaining segments
            for (int i = 1; i < NUM_SEG; i = i + 1) begin
                a_seg[i] <= adda[i*SEG_WIDTH +: SEG_WIDTH];
                b_seg[i] <= addb[i*SEG_WIDTH +: SEG_WIDTH];
            end
        end
        
        // Pipeline stages processing
        for (int stage = 1; stage < PIPELINE_DEPTH; stage = stage + 1) begin
            if (en_pipe[stage-1]) begin
                {carry_pipe[stage][stage+1], sum_seg[stage]} <= 
                    a_seg[stage] + b_seg[stage] + carry_pipe[stage-1][stage];
                carry_pipe[stage][stage:0] <= carry_pipe[stage-1][stage:0];
            end
        end
        
        // Output generation
        if (en_pipe[PIPELINE_DEPTH-1]) begin
            // Combine all segment sums and final carry
            result[DATA_WIDTH:0] <= {carry_pipe[PIPELINE_DEPTH-1][NUM_SEG], sum_seg[NUM_SEG-1][SEG_WIDTH-1:0]};
            for (int j = NUM_SEG-2; j >= 0; j = j - 1) begin
                result[(j+1)*SEG_WIDTH +: SEG_WIDTH] <= sum_seg[j][SEG_WIDTH-1:0];
            end
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule