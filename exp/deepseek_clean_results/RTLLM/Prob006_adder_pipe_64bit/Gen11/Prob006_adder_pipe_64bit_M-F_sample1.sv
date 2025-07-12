module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Fixed parameters - now self-contained
localparam SEG_WIDTH = 8;    // Bits per segment
localparam NUM_SEG = 8;      // Number of segments (64/8)

// Pipeline registers
reg [63:0] a_pipe [0:NUM_SEG-1];
reg [63:0] b_pipe [0:NUM_SEG-1];
reg [SEG_WIDTH:0] sum_pipe [0:NUM_SEG-1]; // +1 bit for carry
reg [NUM_SEG:0] en_pipe; // Gray coded enable pipeline

// Segment carry signals
wire [NUM_SEG:0] carry;
assign carry[0] = 1'b0; // Initial carry-in

// Generate segments
genvar i;
generate
    for (i = 0; i < NUM_SEG; i = i + 1) begin : SEGMENTS
        // Current segment of operands
        wire [SEG_WIDTH-1:0] a_seg = a_pipe[i][(i+1)*SEG_WIDTH-1:i*SEG_WIDTH];
        wire [SEG_WIDTH-1:0] b_seg = b_pipe[i][(i+1)*SEG_WIDTH-1:i*SEG_WIDTH];
        
        // Carry-select addition
        wire [SEG_WIDTH:0] sum0 = {1'b0, a_seg} + {1'b0, b_seg};
        wire [SEG_WIDTH:0] sum1 = sum0 + 1'b1;
        
        // Select correct sum based on carry
        wire [SEG_WIDTH:0] seg_sum = carry[i] ? sum1 : sum0;
        assign carry[i+1] = seg_sum[SEG_WIDTH];
        
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                a_pipe[i] <= 64'b0;
                b_pipe[i] <= 64'b0;
                sum_pipe[i] <= {(SEG_WIDTH+1){1'b0}};
            end else if (en_pipe[i]) begin
                if (i == 0) begin
                    a_pipe[i] <= adda;
                    b_pipe[i] <= addb;
                end else begin
                    a_pipe[i] <= a_pipe[i-1];
                    b_pipe[i] <= b_pipe[i-1];
                end
                sum_pipe[i] <= seg_sum;
            end
        end
    end
endgenerate

// Pipeline control and output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        en_pipe <= {(NUM_SEG+1){1'b0}};
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Shift enable through pipeline
        en_pipe <= {en_pipe[NUM_SEG-1:0], i_en};
        
        // Generate output when final stage is enabled
        if (en_pipe[NUM_SEG]) begin
            result <= {carry[NUM_SEG],
                      sum_pipe[7][7:0],
                      sum_pipe[6][7:0],
                      sum_pipe[5][7:0],
                      sum_pipe[4][7:0],
                      sum_pipe[3][7:0],
                      sum_pipe[2][7:0],
                      sum_pipe[1][7:0],
                      sum_pipe[0][7:0]};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule