module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);
  // Parameters
  localparam SIZE = 16;

  // Internal signals for next state
  reg [SIZE-1:0] grid [0:SIZE-1];       // current grid rows
  reg [SIZE-1:0] next_grid [0:SIZE-1];  // next grid rows

  integer r, c;

  // Unpack q into grid rows for easier indexing
  always @(*) begin
    for (r = 0; r < SIZE; r = r + 1) begin
      grid[r] = q[(r+1)*SIZE-1 -: SIZE];
    end
  end

  // Combinational logic to compute next state
  always @(*) begin
    for (r = 0; r < SIZE; r = r + 1) begin
      for (c = 0; c < SIZE; c = c + 1) begin
        integer nr, nc;
        integer neighbor_count;
        neighbor_count = 0;

        // Check all 8 neighbors with wrap-around
        // Row offsets: -1, 0, +1
        // Col offsets: -1, 0, +1
        // Skip center (r,c)
        for (nr = -1; nr <= 1; nr = nr + 1) begin
          for (nc = -1; nc <= 1; nc = nc + 1) begin
            if (!(nr == 0 && nc == 0)) begin
              integer rr, cc;
              rr = (r + nr + SIZE) % SIZE;
              cc = (c + nc + SIZE) % SIZE;
              neighbor_count = neighbor_count + grid[rr][cc];
            end
          end
        end

        // Apply rules:
        // 0-1 neighbor: 0
        // 2 neighbors: same
        // 3 neighbors: 1
        // 4+ neighbors: 0
        if (neighbor_count <= 1) begin
          next_grid[r][c] = 1'b0;
        end else if (neighbor_count == 2) begin
          next_grid[r][c] = grid[r][c];
        end else if (neighbor_count == 3) begin
          next_grid[r][c] = 1'b1;
        end else begin
          next_grid[r][c] = 1'b0;
        end
      end
    end
  end

  // Pack next_grid into a vector
  wire [255:0] next_q;
  generate
    genvar rr;
    for (rr = 0; rr < SIZE; rr = rr + 1) begin : pack_rows
      assign next_q[(rr+1)*SIZE-1 -: SIZE] = next_grid[rr];
    end
  endgenerate

  // Sequential logic: load or update q at clock edge
  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      q <= next_q;
    end
  end

endmodule