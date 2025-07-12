module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    integer i, row, col;
    always @(*) begin
        for (i = 0; i < 256; i = i + 1) begin
            row = i >> 4;       // i / 16
            col = i & 15;       // i % 16
            
            // Calculate neighbor positions with wrapping using bitwise AND
            wire [7:0] neighbors;
            neighbors[0] = q[((row-1)&15)*16 + ((col-1)&15)]; // top-left
            neighbors[1] = q[((row-1)&15)*16 + col];          // top
            neighbors[2] = q[((row-1)&15)*16 + ((col+1)&15)]; // top-right
            neighbors[3] = q[row*16 + ((col-1)&15)];          // left
            neighbors[4] = q[row*16 + ((col+1)&15)];          // right
            neighbors[5] = q[((row+1)&15)*16 + ((col-1)&15)]; // bottom-left
            neighbors[6] = q[((row+1)&15)*16 + col];          // bottom
            neighbors[7] = q[((row+1)&15)*16 + ((col+1)&15)]; // bottom-right
            
            // Count live neighbors
            wire [3:0] neighbor_count = neighbors[0] + neighbors[1] + neighbors[2] + neighbors[3] +
                                       neighbors[4] + neighbors[5] + neighbors[6] + neighbors[7];
            
            // Apply game rules
            next_q[i] = (neighbor_count == 3) ? 1'b1 :
                       (neighbor_count == 2) ? q[i] :
                       1'b0;
        end
    end

    always @(posedge clk) begin
        q <= load ? data : next_q;
    end

endmodule