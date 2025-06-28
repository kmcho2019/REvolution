module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

  // 16x16 grid toroid neighbors
  function [2:0] num_neighbors;
    input [7:0] r, c;
    reg [2:0] count;

    begin
      count = 
        q[{r-1+16'd16, c-1+16'd16}] + q[{r-1+16'd16, c+16'd16}] + q[{r-1+16'd16, c+1}] +
        q[{r+16'd16, c-1+16'd16}] + q[{r+16'd16, c+1}] +
        q[{r+1, c-1+16'd16}] + q[{r+1, c+16'd16}] + q[{r+1, c+1}];
      num_neighbors = count;
    end
  endfunction

  // Rule to determine next state based on neighbors
  always @(data or q)
  begin
    if (load) // Load initial state
      q <= data;
    else // Update game state
      begin
        for (int i = 0; i < 16; i = i + 1)
          for (int j = 0; j < 16; j = j + 1)
            case (num_neighbors(i, j))
              0, 1: q[{i, j}] <= 1'b0;
              2: q[{i, j}] <= q[{i, j}];
              3: q[{i, j}] <= 1'b1;
              4, 5, 6, 7, 8: q[{i, j}] <= 1'b0;
            endcase
      end
  end

endmodule