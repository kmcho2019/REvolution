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
            wire [7:0] neighbors = {
                q[((row+1)&15)*16 + ((col+1)&15)],  // bottom-right
                q[((row+1)&15)*16 + col],           // bottom
                q[((row+1)&15)*16 + ((col+15)&15)],  // bottom-left
                q[row*16 + ((col+1)&15)],            // right
                q[row*16 + ((col+15)&15)],           // left
                q[((row+15)&15)*16 + ((col+1)&15)],  // top-right
                q[((row+15)&15)*16 + col],           // top
                q[((row+15)&15)*16 + ((col+15)&15)]  // top-left
            };
            
            // Count live neighbors
            wire [3:0] neighbor_count = neighbors[0] + neighbors[1] + neighbors[2] + neighbors[3] +
                                       neighbors[4] + neighbors[5] + neighbors[6] + neighbors[7];
            
            // Apply game rules
            next_q[i] = (neighbor_count == 3) ? 1'b1 :
                       (neighbor_count == 2) ? q[i] :
                       1'b0;
        end
    end

    // State update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule