module NeighborsCalculator (
  input [255:0] q,
  input [7:0] cell_row,
  input [3:0] cell_col,
  output reg [3:0] num_neighbors
);
	
  always @* begin
    int right_col, left_col, top_row, bottom_row;

    right_col = (cell_col + 1) & 15;
    left_col = (cell_col - 1) & 15;
    top_row = (cell_row + 1) & 15;
    bottom_row = (cell_row - 1) & 15;

    num_neighbors = q[top_row*16 + cell_col] + q[bottom_row*16 + cell_col] +
                    q[cell_row*16 + right_col] + q[cell_row*16 + left_col] +
                    q[top_row*16 + right_col] + q[top_row*16 + left_col] +
                    q[bottom_row*16 + right_col] + q[bottom_row*16 + left_col];
  end
endmodule

module CellStateUpdater (
  input [3:0] num_neighbors,
  input cell_state,
  output reg next_state
);
	
  always @* begin
    case(num_neighbors)
      3: next_state = 1;  // Cell becomes alive
      2: next_state = cell_state;  // Cell state does not change
      default: next_state = 0;  // Cell becomes dead
    endcase
  end
endmodule

module ToroidalGrid (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);
	
  reg [255:0] next_q;
  wire [3:0] num_neighbors;
  reg [255:0] q_temp;

  // Calculate next state for each cell
  genvar i, j;
  generate
    for (i = 0; i < 16; i = i + 1) begin: ROW_LOOP
      for (j = 0; j < 16; j = j + 1) begin: COL_LOOP
        NeighborsCalculator neighbors_inst (
          .q(q_temp),
          .cell_row(i),
          .cell_col(j),
          .num_neighbors(num_neighbors)
        );

        CellStateUpdater state_inst (
          .num_neighbors(num_neighbors),
          .cell_state(q_temp[i*16 + j]),
          .next_state(next_q[i*16 + j])
        );
      end
    end
  endgenerate

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end
    else begin
      q <= next_q;
      q_temp <= next_q; // Update q_temp for next iteration
    end
  end

endmodule