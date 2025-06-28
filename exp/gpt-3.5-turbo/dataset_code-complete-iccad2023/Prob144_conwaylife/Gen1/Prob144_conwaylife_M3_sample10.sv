module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

// Function to count alive neighbors for a cell at position (i, j) with toroidal wrap-around
function integer count_neighbors;
  input [255:0] grid;
  input i, j;
  begin
    integer count;
    count = grid[i*16 + ((j+1) & 15)] + grid[i*16 + ((j-1) & 15)] + grid[((i+1) & 15)*16 + j] +
            grid[((i-1) & 15)*16 + j] + grid[((i+1) & 15)*16 + ((j+1) & 15)] +
            grid[((i+1) & 15)*16 + ((j-1) & 15)] + grid[((i-1) & 15)*16 + ((j+1) & 15)] +
            grid[((i-1) & 15)*16 + ((j-1) & 15)];
    count = (grid[i*16 + j] == 1) ? count : count + 2; // Add 2 if the current cell is alive
    return count;
  end
endfunction

// Update game state every clock cycle
always @(posedge clk) begin
  if (load) begin
    q <= data;
  end else begin
    reg [255:0] next_q;

    for (int i = 0; i < 16; i = i + 1) begin
      for (int j = 0; j < 16; j = j + 1) begin
        integer neighbors = count_neighbors(q, i, j);
        
        if (neighbors == 3 || neighbors == 4) begin
          next_q[i*16 + j] = 1; // Cell becomes 1
        end else begin
          next_q[i*16 + j] = 0; // Cell becomes 0
        end
      end
    end
    q <= next_q;
  end
end

endmodule