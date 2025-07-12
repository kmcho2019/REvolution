module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Segment parameters
localparam SEG_WIDTH = 8;
localparam NUM_SEG = 8;

// Pipeline registers
reg [63:0] a_pipe [0:NUM_SEG];
reg [63:0] b_pipe [0:NUM_SEG];
reg [SEG_WIDTH:0] sum_pipe [1:NUM_SEG];
reg en_pipe [0:NUM_SEG];

// Carry signals
wire [NUM_SEG:0] carry;
assign carry[0] = 1'b0;

// Bypass detection
wire inputs_changed = (a_pipe[0] != adda) || (b_pipe[0] != addb);
wire bypass_active = !inputs_changed && en_pipe[0];

// Segment adders
genvar i;
generate
    for (i = 0; i < NUM_SEG; i = i + 1) begin : SEGMENTS
        wire [SEG_WIDTH-1:0] a_seg = a_pipe[i][(i+1)*SEG_WIDTH-1:i*SEG_WIDTH];
        wire [SEG_WIDTH-1:0] b_seg = b_pipe[i][(i+1)*SEG_WIDTH-1:i*SEG_WIDTH];
        wire [SEG_WIDTH:0] seg_sum;
        
        // Carry-select adder segment
        wire [SEG_WIDTH:0] sum0 = {1'b0, a_seg} + {1'b0, b_seg};
        wire [SEG_WIDTH:0] sum1 = sum0 + 1'b1;
        assign seg_sum = carry[i] ? sum1 : sum0;
        assign carry[i+1] = seg_sum[SEG_WIDTH];
        
        // Assign sum to pipeline
        always @(*) begin
            sum_pipe[i+1] = seg_sum;
        end
    end
endgenerate

// Pipeline sequential logic
integer j;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        for (j = 0; j <= NUM_SEG; j = j + 1) begin
            a_pipe[j] <= 64'b0;
            b_pipe[j] <= 64'b0;
            en_pipe[j] <= 1'b0;
            if (j > 0) sum_pipe[j] <= {SEG_WIDTH+1{1'b0}};
        end
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Input stage
        a_pipe[0] <= adda;
        b_pipe[0] <= addb;
        en_pipe[0] <= i_en;
        
        // Pipeline propagation
        if (!bypass_active) begin
            for (j = 1; j <= NUM_SEG; j = j + 1) begin
                a_pipe[j] <= a_pipe[j-1];
                b_pipe[j] <= b_pipe[j-1];
                en_pipe[j] <= en_pipe[j-1];
            end
        end
        
        // Output stage
        if (en_pipe[NUM_SEG]) begin
            result <= {carry[NUM_SEG], 
                      sum_pipe[8][7:0], sum_pipe[7][7:0], sum_pipe[6][7:0], sum_pipe[5][7:0],
                      sum_pipe[4][7:0], sum_pipe[3][7:0], sum_pipe[2][7:0], sum_pipe[1][7:0]};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule