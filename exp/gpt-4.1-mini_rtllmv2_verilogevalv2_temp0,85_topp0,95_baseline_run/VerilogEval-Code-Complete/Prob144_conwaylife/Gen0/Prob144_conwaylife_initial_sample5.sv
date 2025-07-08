module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);
  // Parameters
  localparam N = 16;

  // Internal signals
  reg [255:0] q_next;

  integer r, c, dr, dc;
  integer nr, nc;
  integer idx, nidx;
  integer count;

  always @(*) begin
    // Default next state same as current
    q_next = q;

    // For each cell
    for (r = 0; r < N; r = r + 1) begin
      for (c = 0; c < N; c = c + 1) begin
        // Count neighbors
        count = 0;
        for (dr = -1; dr <= 1; dr = dr + 1) begin
          for (dc = -1; dc <= 1; dc = dc + 1) begin
            if (!(dr == 0 && dc == 0)) begin
              nr = (r + dr + N) % N;
              nc = (c + dc + N) % N;
              nidx = nr * N + nc;
              count = count + q[nidx];
            end
          end
        end

        idx = r * N + c;
        // Apply rules
        if (count <= 1)
          q_next[idx] = 1'b0;
        else if (count == 2)
          q_next[idx] = q[idx];
        else if (count == 3)
          q_next[idx] = 1'b1;
        else // count >= 4
          q_next[idx] = 1'b0;
      end
    end
  end

  // Update state on clock edge or load input
  always @(posedge clk) begin
    if (load)
      q <= data;
    else
      q <= q_next;
  end
endmodule