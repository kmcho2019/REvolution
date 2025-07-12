module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    wire [255:0] next_q;
    integer i, j, x, y;
    integer row, col;
    integer neighbor_count;

    always @* begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                // Calculate neighbor count with wrap-around
                neighbor_count = 0;
                
                for (x = -1; x <= 1; x = x + 1) begin
                    for (y = -1; y <= 1; y = y + 1) begin
                        if (x == 0 && y == 0) continue; // Skip self
                        
                        // Calculate wrapped coordinates
                        row = (i + x + 16) % 16;
                        col = (j + y + 16) % 16;
                        
                        // Check neighbor state
                        if (q[row * 16 + col]) begin
                            neighbor_count = neighbor_count + 1;
                        end
                    end
                end
                
                // Apply game rules
                case (neighbor_count)
                    0, 1: next_q[i*16 + j] = 1'b0;
                    2:    next_q[i*16 + j] = q[i*16 + j];
                    3:    next_q[i*16 + j] = 1'b1;
                    default: next_q[i*16 + j] = 1'b0;
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