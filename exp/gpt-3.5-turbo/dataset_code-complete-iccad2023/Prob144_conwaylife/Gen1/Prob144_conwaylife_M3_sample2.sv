module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

  reg [255:0] next_q;

  function integer count_neighbors;
    input i, j;
    integer count;
    begin
      count = q[((i+15)%16)*16 + (j+15)%16] + q[((i+15)%16)*16 + j] + q[((i+15)%16)*16 + (j+1)%16] +
              q[(i*16 + (j+15)%16)] + q[(i*16 + (j+1)%16)] +
              q[((i+1)%16)*16 + (j+15)%16] + q[((i+1)%16)*16 + j] + q[((i+1)%16)*16 + (j+1)%16];
    end
  endfunction

  always @(posedge clk)
  begin
    if (load)
      q <= data;
    else
      begin
        for (int i = 0; i < 16; i = i + 1)
          for (int j = 0; j < 16; j = j + 1)
            begin
              integer neighbors = count_neighbors(i, j);
              case (neighbors)
                0, 1: next_q[i*16 + j] = 1'b0;
                2: next_q[i*16 + j] = q[i*16 + j];
                3: next_q[i*16 + j] = 1'b1;
                4, 5, 6, 7, 8: next_q[i*16 + j] = 1'b0;
              endcase
            end
        q <= next_q;
      end
  end

endmodule