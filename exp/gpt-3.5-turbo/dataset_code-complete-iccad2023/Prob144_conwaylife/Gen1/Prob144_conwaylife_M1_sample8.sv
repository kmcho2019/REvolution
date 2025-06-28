module NeighborsCalculator (
  input [255:0] q,
  input [7:0] row_idx,
  input [7:0] col_idx,
  output reg [3:0] neighbors
);

  always @* begin
    int i;
    neighbors = 0;
    for (i = 0; i < 8; i = i + 1) begin
      // Calculate number of neighbors for cell (row_idx, col_idx) on the toroidal grid
      if (q[((row_idx + i - 1) & 15) * 16 + ((col_idx - 1) & 15)]) neighbors = neighbors + 1;
      if (q[((row_idx + i - 1) & 15) * 16 + ((col_idx + 1) & 15)]) neighbors = neighbors + 1;
    end
    if (q[((row_idx - 1) & 15) * 16 + col_idx]) neighbors = neighbors + 1;
    if (q[((row_idx + 1) & 15) * 16 + col_idx]) neighbors = neighbors + 1;
  end
endmodule

module CellUpdater (
  input [3:0] neighbors,
  input cur_state,
  output reg next_state
);

  always @* begin
    case(neighbors)
      4'b0011, 4'b0010: next_state = cur_state;
      4'b0012: next_state = 1;
      default: next_state = 0;
    endcase
  end
endmodule

module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

  reg [255:0] next_q;
  reg [7:0] row_idx, col_idx;
  reg [3:0] num_neighbors;

  // NeighborsCalculator instances for each cell
  genvar i, j;
  generate
    for (i = 0; i < 16; i = i + 1) begin : gen_row
      for (j = 0; j < 16; j = j + 1) begin : gen_col
        NeighborsCalculator neighbors_calc (
          .q(q),
          .row_idx(i),
          .col_idx(j),
          .neighbors(num_neighbors)
        );
        
        CellUpdater cell_upd (
          .neighbors(num_neighbors),
          .cur_state(q[i*16 + j]),
          .next_state(next_q[i*16 + j])
        );
      end
    end
  endgenerate

  // Sequential logic for updating the grid
  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end
    else begin
      q <= next_q;
    end
  end

endmodule