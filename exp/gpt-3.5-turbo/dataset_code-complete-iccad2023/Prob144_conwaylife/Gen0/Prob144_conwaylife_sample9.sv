module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

reg [255:0] q_next; // Create a new state variable to update

// Function to count the number of alive neighbors for a given cell
function automatic integer count_neighbors;
  input integer idx;
  reg [1:0] row, col;
  integer count;

  row = idx / 16;
  col = idx % 16;
  count = q[(row-1+16)%16*16 + (col-1+16)%16] + q[(row-1+16)%16*16 + col] +
          q[(row-1+16)%16*16 + (col+1)%16] + q[row*16 + (col-1+16)%16] +
          q[row*16 + (col+1)%16] + q[(row+1)%16*16 + (col-1+16)%16] +
          q[(row+1)%16*16 + col] + q[(row+1)%16*16 + (col+1)%16];

  return count;
endfunction

// Update each cell in the grid based on neighbor count
always @ (posedge clk) begin
  if (load) begin
    q <= data; // Load initial state
  end else begin
    for (int i = 0; i < 256; i = i + 1) begin
      case(count_neighbors(i))
        0, 1: q_next[i] <= 0;
        2: q_next[i] <= q[i];
        3: q_next[i] <= 1;
        default: q_next[i] <= 0;
      endcase
    end
    q <= q_next;
  end
end

endmodule