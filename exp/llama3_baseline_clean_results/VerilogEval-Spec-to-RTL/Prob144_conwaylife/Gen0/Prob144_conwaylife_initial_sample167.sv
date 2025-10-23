module TopModule(
  input clk,
  input load,
  input [255:0] data,
  output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

integer i, j, k;
integer alive_neighbours;

always @(*) begin
  // Initialize next_state with current_state
  next_state = current_state;

  // Count alive neighbours for each cell and update next_state
  for (i = 0; i < 16; i++) begin
    for (j = 0; j < 16; j++) begin
      alive_neighbours = 0;
      for (k = -1; k <= 1; k++) begin
        for (integer l = -1; l <= 1; l++) begin
          if ((k != 0 || l != 0) && current_state[((((i + k + 16) % 16) * 16) + ((j + l + 16) % 16))]) begin
            alive_neighbours++;
          end
        end
      end
      if (current_state[((i * 16) + j)]) begin
        // Cell is alive
        if (alive_neighbours < 2 || alive_neighbours > 3) begin
          next_state[((i * 16) + j)] = 1'b0;
        end
      end else begin
        // Cell is dead
        if (alive_neighbours == 3) begin
          next_state[((i * 16) + j)] = 1'b1;
        end
      end
    end
  end
end

always @(posedge clk) begin
  if (load) begin
    current_state <= data;
  end else begin
    current_state <= next_state;
  end
end

assign q = current_state;

endmodule