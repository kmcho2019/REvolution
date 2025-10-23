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
reg [WIDTH-1:0] q_pipe [SEGMENTS-2:0];
wire clk_gated;
reg load_reg;

// Clock gating logic
assign clk_gated = clk & (load | |next_q ^ q);

// Boundary conditions
wire left_boundary = 1'b0;
wire right_boundary = 1'b0;

genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin: rule90
        wire left_neighbor = (i == 0) ? left_boundary : 
                           (i <= SEG_WIDTH) ? q[i-1] :
                           (i <= 2*SEG_WIDTH) ? q_pipe[0][i-1] :
                           (i <= 3*SEG_WIDTH) ? q_pipe[1][i-1] : q_pipe[2][i-1];
                           
        wire right_neighbor = (i == WIDTH-1) ? right_boundary : 
                            (i < SEG_WIDTH) ? q[i+1] :
                            (i < 2*SEG_WIDTH) ? q_pipe[0][i+1] :
                            (i < 3*SEG_WIDTH) ? q_pipe[1][i+1] : q_pipe[2][i+1];
                            
        assign next_q[i] = left_neighbor ^ right_neighbor;
    end
endgenerate

always @(posedge clk_gated) begin
    load_reg <= load;
    
    if (load) begin
        q <= data;
        // Clear pipeline registers on load
        for (integer j = 0; j < SEGMENTS-1; j = j+1)
            q_pipe[j] <= '0;
    end else begin
        // Pipeline stages
        q_pipe[0] <= q[SEG_WIDTH*3-1:SEG_WIDTH*2];
        q_pipe[1] <= q[SEG_WIDTH*2-1:SEG_WIDTH];
        q_pipe[2] <= q[SEG_WIDTH-1:0];
        
        q <= next_q;
    end
end

endmodule