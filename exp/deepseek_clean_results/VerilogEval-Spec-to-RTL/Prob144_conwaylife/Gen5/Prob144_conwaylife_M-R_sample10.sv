module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_state;
    
    // Neighbor counting and state update for all cells
    integer i, j;
    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                // Compute neighbor indices with bitwise masking
                integer n0 = ((i-1)&15)*16 + ((j-1)&15);
                integer n1 = ((i-1)&15)*16 + (j&15);
                integer n2 = ((i-1)&15)*16 + ((j+1)&15);
                integer n3 = (i&15)*16 + ((j-1)&15);
                integer n4 = (i&15)*16 + ((j+1)&15);
                integer n5 = ((i+1)&15)*16 + ((j-1)&15);
                integer n6 = ((i+1)&15)*16 + (j&15);
                integer n7 = ((i+1)&15)*16 + ((j+1)&15);
                
                // Count live neighbors
                integer count = q[n0] + q[n1] + q[n2] + 
                               q[n3] + q[n4] + q[n5] + 
                               q[n6] + q[n7];
                
                // State update rules
                next_state[i*16+j] = (count == 3) || (count == 2 && q[i*16+j]);
            end
        end
    end

    // Synchronous update with load mux
    always @(posedge clk) begin
        q <= load ? data : next_state;
    end

endmodule