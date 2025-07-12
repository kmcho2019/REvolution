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
        $error("DATA_WIDTH must be divisible by SEG_WIDTH");
        $finish;
    end
end

localparam NUM_SEG = DATA_WIDTH / SEG_WIDTH;
localparam PIPELINE_DEPTH = NUM_SEG;

// Pipeline registers - only store relevant bits
reg [SEG_WIDTH-1:0] a_pipe [0:PIPELINE_DEPTH-1];
reg [SEG_WIDTH-1:0] b_pipe [0:PIPELINE_DEPTH-1];
reg [SEG_WIDTH:0] sum_pipe [0:PIPELINE_DEPTH-1]; // +1 bit for carry
reg [PIPELINE_DEPTH:0] en_pipe = '0; // Binary enable pipeline

// Segment carry signals
wire [NUM_SEG:0] carry;
assign carry[0] = 1'b0; // Initial carry-in

// Generate segments
genvar i;
generate
    for (i = 0; i < NUM_SEG; i = i + 1) begin : SEGMENTS
        // Current segment of operands
        wire [SEG_WIDTH-1:0] a_seg = (i == 0) ? adda[SEG_WIDTH-1:0] : a_pipe[i-1];
        wire [SEG_WIDTH-1:0] b_seg = (i == 0) ? addb[SEG_WIDTH-1:0] : b_pipe[i-1];
        
        // Carry-select addition
        wire [SEG_WIDTH:0] sum0 = {1'b0, a_seg} + {1'b0, b_seg};
        wire [SEG_WIDTH:0] sum1 = sum0 + 1'b1;
        
        // Select correct sum based on carry
        wire [SEG_WIDTH:0] seg_sum = carry[i] ? sum1 : sum0;
        assign carry[i+1] = seg_sum[SEG_WIDTH];
        
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                a_pipe[i] <= '0;
                b_pipe[i] <= '0;
                sum_pipe[i] <= '0;
            end else if (en_pipe[i]) begin
                if (i < NUM_SEG-1) begin
                    a_pipe[i] <= adda[(i+1)*SEG_WIDTH +: SEG_WIDTH];
                    b_pipe[i] <= addb[(i+1)*SEG_WIDTH +: SEG_WIDTH];
                end
                sum_pipe[i] <= seg_sum;
            end
        end
    end
endgenerate

// Pipeline control and output
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        en_pipe <= '0;
        result <= '0;
        o_en <= 1'b0;
    end else begin
        // Shift enable through pipeline
        en_pipe <= {en_pipe[PIPELINE_DEPTH-1:0], i_en};
        
        // Generate output when final stage is enabled
        if (en_pipe[PIPELINE_DEPTH]) begin
            result <= {carry[NUM_SEG], 
                      sum_pipe[NUM_SEG-1][SEG_WIDTH-1:0]};
            for (int j = NUM_SEG-1; j > 0; j--) begin
                result[(j)*SEG_WIDTH +: SEG_WIDTH] <= sum_pipe[j-1][SEG_WIDTH-1:0];
            end
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule