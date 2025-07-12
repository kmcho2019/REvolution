module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

parameter WIDTH = 512;
parameter SEGMENTS = 4;
parameter SEG_SIZE = WIDTH/SEGMENTS;

wire [WIDTH-1:0] next_q;
reg [WIDTH-1:0] q_pipe [SEGMENTS-1:0];
wire update_enable = load || (|next_q ^ q); // Enable if loading or state changing

// Boundary conditions
wire left_boundary = 1'b0;
wire right_boundary = 1'b0;

// Pipeline stage 0: First 128 bits
genvar i;
generate
    for (i = 0; i < SEG_SIZE; i = i + 1) begin: stage0
        wire left = (i == 0) ? left_boundary : q[i-1];
        wire right = (i == SEG_SIZE-1) ? q[i+1] : q[i+1];
        assign next_q[i] = left ^ right;
    end
    
    // Pipeline stages 1-3
    for (i = SEG_SIZE; i < WIDTH; i = i + 1) begin: other_stages
        wire left = (i == 0) ? left_boundary : 
                   (i % SEG_SIZE == 0) ? q_pipe[i/SEG_SIZE-1][SEG_SIZE-1] : q[i-1];
        wire right = (i == WIDTH-1) ? right_boundary : 
                    ((i+1) % SEG_SIZE == 0) ? q_pipe[(i+1)/SEG_SIZE-1][0] : q[i+1];
        assign next_q[i] = left ^ right;
    end
endgenerate

always @(posedge clk) begin
    if (load) begin
        q <= data;
        for (integer j = 0; j < SEGMENTS; j = j + 1)
            q_pipe[j] <= 0;
    end else if (update_enable) begin
        // Pipeline registers
        q_pipe[0] <= next_q[SEG_SIZE-1:0];
        for (integer j = 1; j < SEGMENTS; j = j + 1)
            q_pipe[j] <= next_q[(j+1)*SEG_SIZE-1:j*SEG_SIZE];
            
        // Final output
        q <= {q_pipe[3], q_pipe[2], q_pipe[1], next_q[SEG_SIZE-1:0]};
    end
end

endmodule