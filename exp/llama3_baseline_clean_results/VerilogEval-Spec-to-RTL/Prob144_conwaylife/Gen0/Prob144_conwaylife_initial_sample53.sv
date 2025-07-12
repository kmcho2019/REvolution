module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Function to count the number of alive neighbors for each cell
    function [2:0] count_neighbors;
        input [255:0] grid;
        input [7:0] row;
        input [7:0] col;
        reg [2:0] count;
        reg [7:0] r, c;
        count = 3'd0;
        
        for (r = 0; r < 8'd3; r = r + 1) begin
            for (c = 0; c < 8'd3; c = c + 1) begin
                if (r!= 1 || c!= 1) begin
                    if (grid[((((row + r - 1) % 16) * 16) + (col + c - 1) % 16)]) begin
                        count = count + 1;
                    end
                end
            end
        end
        
        count_neighbors = count;
    endfunction

    // Update the state of each cell based on the game rules
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            for (int i = 0; i < 16; i = i + 1) begin
                for (int j = 0; j < 16; j = j + 1) begin
                    reg [2:0] neighbors;
                    reg cell;
                    cell = q[i * 16 + j];
                    neighbors = count_neighbors(q, i, j);
                    
                    case (neighbors)
                        3'd0, 3'd1: q[i * 16 + j] <= 1'd0;
                        3'd2: q[i * 16 + j] <= cell;
                        3'd3: q[i * 16 + j] <= 1'd1;
                        default: q[i * 16 + j] <= 1'd0;
                    endcase
                end
            end
        end
    end

endmodule