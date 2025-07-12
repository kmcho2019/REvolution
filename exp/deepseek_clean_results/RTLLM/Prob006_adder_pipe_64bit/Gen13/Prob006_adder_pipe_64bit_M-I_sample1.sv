module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline parameters
localparam STAGES = 4;
localparam SEG_WIDTH = 16;  // 64-bit / 4 stages = 16 bits per stage

// Pipeline registers
reg [63:0] a_pipe [0:STAGES-1];
reg [63:0] b_pipe [0:STAGES-1];
reg [SEG_WIDTH:0] sum_pipe [0:STAGES-1]; // +1 bit for carry
reg en_pipe [0:STAGES];

// Carry signals
wire [STAGES:0] carry;

// Initialize carry chain
assign carry[0] = 1'b0;

// Pipeline adder segments
genvar i;
generate
    for (i = 0; i < STAGES; i = i + 1) begin : SEGMENTS
        wire [SEG_WIDTH-1:0] a_seg = a_pipe[i][(i+1)*SEG_WIDTH-1:i*SEG_WIDTH];
        wire [SEG_WIDTH-1:0] b_seg = b_pipe[i][(i+1)*SEG_WIDTH-1:i*SEG_WIDTH];
        
        // Ripple carry adder segment
        assign {carry[i+1], sum_pipe[i][SEG_WIDTH-1:0]} = 
            a_seg + b_seg + carry[i];
        assign sum_pipe[i][SEG_WIDTH] = carry[i+1];
    end
endgenerate

// Pipeline sequential logic
integer j;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        for (j = 0; j < STAGES; j = j + 1) begin
            a_pipe[j] <= 64'b0;
            b_pipe[j] <= 64'b0;
            sum_pipe[j] <= {(SEG_WIDTH+1){1'b0}};
        end
        for (j = 0; j <= STAGES; j = j + 1) begin
            en_pipe[j] <= 1'b0;
        end
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Input stage
        a_pipe[0] <= adda;
        b_pipe[0] <= addb;
        en_pipe[0] <= i_en;
        
        // Pipeline propagation
        for (j = 1; j < STAGES; j = j + 1) begin
            a_pipe[j] <= a_pipe[j-1];
            b_pipe[j] <= b_pipe[j-1];
        end
        for (j = 1; j <= STAGES; j = j + 1) begin
            en_pipe[j] <= en_pipe[j-1];
        end
        
        // Output stage
        if (en_pipe[STAGES]) begin
            result <= {carry[STAGES],
                      sum_pipe[3][15:0],
                      sum_pipe[2][15:0],
                      sum_pipe[1][15:0],
                      sum_pipe[0][15:0]};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule