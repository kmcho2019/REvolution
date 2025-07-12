module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    function automatic get_cell;
        input [7:0] row, col;
        begin
            // Handle wrap-around for toroidal grid
            row = row % 16;
            col = col % 16;
            get_cell = q[row*16 + col];
        end
    endfunction

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Temporary storage for next state
            reg [255:0] next_q;
            
            for (integer row = 0; row < 16; row = row + 1) begin
                for (integer col = 0; col < 16; col = col + 1) begin
                    // Count live neighbors (8 neighbors)
                    integer neighbors = 0;
                    integer r, c;
                    
                    // Check all 8 neighbors
                    for (integer i = -1; i <= 1; i = i + 1) begin
                        for (integer j = -1; j <= 1; j = j + 1) begin
                            if (i == 0 && j == 0) continue; // Skip self
                            r = row + i;
                            c = col + j;
                            neighbors = neighbors + get_cell(r, c);
                        end
                    end
                    
                    // Apply game rules
                    case (neighbors)
                        0, 1: next_q[row*16 + col] = 1'b0; // Dies
                        2: next_q[row*16 + col] = q[row*16 + col]; // Stays same
                        3: next_q[row*16 + col] = 1'b1; // Becomes alive
                        default: next_q[row*16 + col] = 1'b0; // Dies (4+ neighbors)
                    endcase
                end
            end
            
            q <= next_q;
        end
    end

endmodule