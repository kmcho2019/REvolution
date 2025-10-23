module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Parameters
localparam SEG_WIDTH = 8;
localparam NUM_SEG = 8;

// Pipeline registers
reg [63:0] a_pipe [0:NUM_SEG];
reg [63:0] b_pipe [0:NUM_SEG];
reg [SEG_WIDTH:0] sum_pipe [0:NUM_SEG]; // +1 bit for carry
reg [NUM_SEG:0] en_pipe; // Gray coded enable pipeline

// Segment carry signals
wire [NUM_SEG:0] carry;
assign carry[0] = 1'b0; // Initial carry-in

// Bypass detection
wire inputs_changed = (a_pipe[0] != adda) || (b_pipe[0] != addb);
wire bypass_active = !inputs_changed && en_pipe[0];

// Generate segments
genvar i;
generate
    for (i = 0; i < NUM_SEG; i = i + 1) begin : SEGMENTS
        // Carry-select style segment adder
        wire [SEG_WIDTH-1:0] a_seg = a_pipe[i][(i+1)*SEG_WIDTH-1:i*SEG_WIDTH];
        wire [SEG_WIDTH-1:0] b_seg = b_pipe[i][(i+1)*SEG_WIDTH-1:i*SEG_WIDTH];
        
        // Compute both possible sums (carry=0 and carry=1)
        wire [SEG_WIDTH:0] sum0 = {1'b0, a_seg} + {1'b0, b_seg};
        wire [SEG_WIDTH:0] sum1 = {1'b0, a_seg} + {1'b0, b_seg} + 1'b1;
        
        // Select correct sum based on incoming carry
        wire [SEG_WIDTH:0] seg_sum = carry[i] ? sum1 : sum0;
        
        // Propagate carry to next segment
        assign carry[i+1] = seg_sum[SEG_WIDTH];
        
        // Detect early termination (all zero operands)
        wire seg_zero = (a_seg == 0) && (b_seg == 0);
        
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                a_pipe[i+1] <= 64'b0;
                b_pipe[i+1] <= 64'b0;
                sum_pipe[i+1] <= {(SEG_WIDTH+1){1'b0}};
            end else if (en_pipe[i] && !bypass_active) begin
                // Normal pipeline operation
                a_pipe[i+1] <= a_pipe[i];
                b_pipe[i+1] <= b_pipe[i];
                
                // For zero segments, force sum to zero to save power
                sum_pipe[i+1] <= seg_zero ? {(SEG_WIDTH+1){1'b0}} : seg_sum;
            end
        end
    end
endgenerate

// Pipeline control logic (Gray coded)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        en_pipe <= {(NUM_SEG+1){1'b0}};
        a_pipe[0] <= 64'b0;
        b_pipe[0] <= 64'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Input stage
        a_pipe[0] <= adda;
        b_pipe[0] <= addb;
        
        // Gray code pipeline enable propagation
        en_pipe[0] <= i_en;
        for (int j = 1; j <= NUM_SEG; j = j + 1) begin
            en_pipe[j] <= en_pipe[j-1];
        end
        
        // Output stage
        if (en_pipe[NUM_SEG]) begin
            // Combine segment sums
            result <= {
                carry[NUM_SEG], // Final carry
                sum_pipe[NUM_SEG][SEG_WIDTH-1:0],
                sum_pipe[NUM_SEG-1][SEG_WIDTH-1:0],
                sum_pipe[NUM_SEG-2][SEG_WIDTH-1:0],
                sum_pipe[NUM_SEG-3][SEG_WIDTH-1:0],
                sum_pipe[NUM_SEG-4][SEG_WIDTH-1:0],
                sum_pipe[NUM_SEG-5][SEG_WIDTH-1:0],
                sum_pipe[NUM_SEG-6][SEG_WIDTH-1:0],
                sum_pipe[NUM_SEG-7][SEG_WIDTH-1:0]
            };
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule