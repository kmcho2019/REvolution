module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    reg [255:0] next_q;
    integer row, col;
    
    always @(*) begin
        for (row = 0; row < 16; row = row + 1) begin
            for (col = 0; col < 16; col = col + 1) begin
                // Calculate neighbor indices with wrap-around using modulo
                wire [3:0] x_prev = (row + 15) % 16;
                wire [3:0] x_next = (row + 1) % 16;
                wire [3:0] y_prev = (col + 15) % 16;
                wire [3:0] y_next = (col + 1) % 16;
                
                // Get neighbor values
                wire [7:0] neighbors = {
                    q[x_prev*16 + y_prev], q[x_prev*16 + col], q[x_prev*16 + y_next],
                    q[row*16 + y_prev],                        q[row*16 + y_next],
                    q[x_next*16 + y_prev], q[x_next*16 + col], q[x_next*16 + y_next]
                };
                
                // Count live neighbors
                wire [3:0] neighbor_count;
                assign neighbor_count = neighbors[0] + neighbors[1] + neighbors[2] + 
                                      neighbors[3] + neighbors[4] + neighbors[5] + 
                                      neighbors[6] + neighbors[7];
                
                // Optimized state update logic
                case (neighbor_count)
                    2: next_q[row*16 + col] = q[row*16 + col];
                    3: next_q[row*16 + col] = 1'b1;
                    default: next_q[row*16 + col] = 1'b0;
                endcase
            end
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule