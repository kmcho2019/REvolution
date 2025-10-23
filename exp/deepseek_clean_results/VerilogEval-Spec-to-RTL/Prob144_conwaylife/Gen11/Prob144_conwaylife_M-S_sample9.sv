module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_state;
    
    genvar i, j;
    generate
        for (i = 0; i < 16; i = i + 1) begin : row
            for (j = 0; j < 16; j = j + 1) begin : col
                // Calculate neighbor positions with wrap-around
                wire [3:0] im1 = (i == 0) ? 15 : i - 1;
                wire [3:0] ip1 = (i == 15) ? 0 : i + 1;
                wire [3:0] jm1 = (j == 0) ? 15 : j - 1;
                wire [3:0] jp1 = (j == 15) ? 0 : j + 1;
                
                // Count live neighbors
                wire [3:0] count = 
                    q[im1*16 + jm1] + q[im1*16 + j] + q[im1*16 + jp1] +
                    q[i*16 + jm1]                   + q[i*16 + jp1] +
                    q[ip1*16 + jm1] + q[ip1*16 + j] + q[ip1*16 + jp1];
                
                // Apply game rules
                assign next_state[i*16 + j] = 
                    (count == 3) || (count == 2 && q[i*16 + j]);
            end
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end

endmodule