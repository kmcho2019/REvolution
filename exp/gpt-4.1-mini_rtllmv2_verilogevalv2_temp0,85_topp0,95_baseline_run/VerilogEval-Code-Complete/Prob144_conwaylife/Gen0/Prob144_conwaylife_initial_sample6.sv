module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);
  // Extract cell state: row r, col c, with wrap-around modulo 16
  function automatic bit get_cell(input [255:0] state, input integer r, input integer c);
    integer rr, cc;
  begin
    rr = (r + 16) % 16;
    cc = (c + 16) % 16;
    get_cell = state[rr*16 + cc];
  end
  endfunction

  integer r,c, dr, dc;
  reg [255:0] next_q;
  reg [3:0] neighbors; // max 8 neighbors => 4 bits suffice

  always @(*) begin
    // Compute next_q combinationally
    for (r=0; r<16; r=r+1) begin
      for (c=0; c<16; c=c+1) begin
        neighbors = 0;
        // Sum neighbors in 3x3 block excluding (r,c)
        for (dr=-1; dr<=1; dr=dr+1) begin
          for (dc=-1; dc<=1; dc=dc+1) begin
            if (!(dr==0 && dc==0)) begin
              neighbors = neighbors + get_cell(q, r+dr, c+dc);
            end
          end
        end

        // Apply rules
        // Current cell state:
        // 0 if dead, 1 if alive
        if (neighbors <= 1)
          next_q[r*16 + c] = 1'b0;
        else if (neighbors == 2)
          next_q[r*16 + c] = get_cell(q, r, c);
        else if (neighbors == 3)
          next_q[r*16 + c] = 1'b1;
        else // neighbors >= 4
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