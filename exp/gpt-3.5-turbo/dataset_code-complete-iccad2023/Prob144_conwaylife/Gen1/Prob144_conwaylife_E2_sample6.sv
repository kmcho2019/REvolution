module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

reg [255:0] next_q;

// Function to count alive neighbors for a cell at position (i, j)
function integer count_neighbors;
  input i, j;
  integer count;
  integer ip1, im1, jp1, jm1;
  begin
    ip1 = (i == 15) ? 0 : i + 1;
    im1 = (i == 0) ? 15 : i - 1;
    jp1 = (j == 15) ? 0 : j + 1;
    jm1 = (j == 0) ? 15 : j - 1;

    count = q[im1*16 + jm1] + q[im1*16 + j] + q[im1*16 + jp1] +
            q[i*16 + jm1] + q[i*16 + jp1] +
            q[ip1*16 + jm1] + q[ip1*16 + j] + q[ip1*16 + jp1];
  end
endfunction

// Update game state every clock cycle
always @(posedge clk) begin
  if (load) begin
    q <= data;
  end else begin
    for (int i = 0; i < 16; i = i + 1) begin
      for (int j = 0; j < 16; j = j + 1) begin
        integer neighbors = count_neighbors(i, j);
        
        if (neighbors <= 1) begin
          next_q[i*16 + j] = 0; // Cell becomes 0
        end else if (neighbors == 2) begin
          next_q[i*16 + j] = q[i*16 + j]; // Cell state does not change
        end else if (neighbors == 3) begin
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