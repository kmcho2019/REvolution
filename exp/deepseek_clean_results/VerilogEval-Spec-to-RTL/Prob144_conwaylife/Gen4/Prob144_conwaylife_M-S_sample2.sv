module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_state;
    integer i, j;
    
    always @(*) begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                // Calculate neighbor indices with wrapping
                integer im1 = (i-1) & 15;
                integer ip1 = (i+1) & 15;
                integer jm1 = (j-1) & 15;
                integer jp1 = (j+1) & 15;
                
                // Count live neighbors
                integer count = 
                    q[im1*16 + jm1] + q[im1*16 + j] + q[im1*16 + jp1] +
                    q[i*16 + jm1]                   + q[i*16 + jp1] +
                    q[ip1*16 + jm1] + q[ip1*16 + j] + q[ip1*16 + jp1];
                
                // Update state based on neighbor count
                next_state[i*16 + j] = (count == 3) || (count == 2 && q[i*16 + j]);
            end
        end
    end

    always @(posedge clk) begin
        q <= load ? data : next_state;
    end

endmodule