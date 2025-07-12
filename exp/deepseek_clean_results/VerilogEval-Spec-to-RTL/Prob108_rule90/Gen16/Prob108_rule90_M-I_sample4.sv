module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

parameter WIDTH = 512;
parameter SEGMENTS = 4;
parameter SEG_WIDTH = WIDTH/SEGMENTS;

wire [WIDTH-1:0] next_q;
reg [WIDTH-1:0] q_pipeline [SEGMENTS-2:0];
wire pipeline_enable = ~load;  // Enable pipeline when not loading

// Boundary conditions
wire left_boundary = 1'b0;
wire right_boundary = 1'b0;

// Pipeline stage 0 (bits 0-127)
genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin: rule90
        wire left_neighbor = (i == 0) ? left_boundary : 
                            (i <= SEG_WIDTH) ? q[i-1] : q_pipeline[0][i-1];
        wire right_neighbor = (i == WIDTH-1) ? right_boundary : 
                             (i < SEG_WIDTH-1) ? q[i+1] : q_pipeline[0][i+1];
        assign next_q[i] = left_neighbor ^ right_neighbor;
    end
endgenerate

// Pipeline registers
always @(posedge clk) begin
    if (load) begin
        q <= data;
        // Clear pipeline registers on load
        for (integer j = 0; j < SEGMENTS-1; j = j + 1) begin
            q_pipeline[j] <= '0;
        end
    end else if (pipeline_enable) begin
        // Stage 1 (128-255)
        q_pipeline[0] <= next_q[2*SEG_WIDTH-1:SEG_WIDTH];
        // Stage 2 (256-383)
        q_pipeline[1] <= next_q[3*SEG_WIDTH-1:2*SEG_WIDTH];
        // Stage 3 (384-511)
        q_pipeline[2] <= next_q[4*SEG_WIDTH-1:3*SEG_WIDTH];
        // Final output (0-127)
        q[SEG_WIDTH-1:0] <= next_q[SEG_WIDTH-1:0];
    end
end

// Output remaining bits from pipeline
always @(*) begin
    q[2*SEG_WIDTH-1:SEG_WIDTH] = q_pipeline[0];
    q[3*SEG_WIDTH-1:2*SEG_WIDTH] = q_pipeline[1];
    q[4*SEG_WIDTH-1:3*SEG_WIDTH] = q_pipeline[2];
end

endmodule