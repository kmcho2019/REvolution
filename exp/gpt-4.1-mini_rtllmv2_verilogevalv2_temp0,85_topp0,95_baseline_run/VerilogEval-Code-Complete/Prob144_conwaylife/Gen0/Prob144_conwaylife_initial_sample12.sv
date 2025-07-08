module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

  // function to compute modulo 16 (wrap around) for index arithmetic
  function [3:0] mod16_add;
    input [3:0] a;
    input signed [4:0] b;
    reg signed [5:0] temp;
    begin
      temp = a + b;
      // add or subtract 16 to wrap around if needed
      if (temp < 0)
        temp = temp + 16;
      else if (temp > 15)
        temp = temp - 16;
      mod16_add = temp[3:0];
    end
  endfunction

  integer r, c;
  reg [7:0] neighbor_count; // max 8 neighbors

  reg [255:0] next_q;

  always @(*) begin
    // default assignment
    next_q = 256'b0;

    // for each cell in 16x16 grid
    for (r = 0; r < 16; r = r + 1) begin
      for (c = 0; c < 16; c = c + 1) begin
        // count neighbors with wrap-around indexing
        neighbor_count = 0;

        // neighbors relative positions (8 neighbors)
        // (-1,-1), (-1,0), (-1,1), (0,-1), (0,1), (1,-1), (1,0), (1,1)
        neighbor_count = neighbor_count +
          q[{mod16_add(r, -1), mod16_add(c, -1)}] +
          q[{mod16_add(r, -1), mod16_add(c,  0)}] +
          q[{mod16_add(r, -1), mod16_add(c,  1)}] +
          q[{mod16_add(r,  0), mod16_add(c, -1)}] +
          q[{mod16_add(r,  0), mod16_add(c,  1)}] +
          q[{mod16_add(r,  1), mod16_add(c, -1)}] +
          q[{mod16_add(r,  1), mod16_add(c,  0)}] +
          q[{mod16_add(r,  1), mod16_add(c,  1)}];

        // Current cell linear index: r*16 + c
        // Compute next state per rules:
        // 0-1 neighbors => 0
        // 2 neighbors => no change
        // 3 neighbors => 1
        // 4+ neighbors => 0

        if (neighbor_count <= 1)
          next_q[r*16 + c] = 1'b0;
        else if (neighbor_count == 2)
          next_q[r*16 + c] = q[r*16 + c];
        else if (neighbor_count == 3)
          next_q[r*16 + c] = 1'b1;
        else
          next_q[r*16 + c] = 1'b0;
      end
    end
  end

  always @(posedge clk) begin
    if (load)
      q <= data;
    else
      q <= next_q;
  end

endmodule