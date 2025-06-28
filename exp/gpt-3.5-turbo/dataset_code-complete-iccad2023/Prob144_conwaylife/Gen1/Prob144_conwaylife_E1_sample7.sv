module NeighborsCalculator (
  input [255:0] q,
  output [255:0] neighbors
);
  genvar i, j;
  generate
    for (i = 0; i < 16; i = i + 1) begin : ROW_LOOP
      for (j = 0; j < 16; j = j + 1) begin : COL_LOOP
        assign neighbors[i*16 + j] = 
          q[((i+15)%16)*16 + ((j+1)%16)] + // Right
          q[((i+15)%16)*16 + ((j+15)%16)] + // Top-right
          q[((i+15)%16)*16 + j] + // Top
          q[(i*16) + ((j+1)%16)] + // Bottom
          q[(i*16) + ((j+15)%16)] + // Bottom-right
          q[(i*16) + j] + // Left
          q[((i+1)%16)*16 + ((j+1)%16)] + // Bottom-left
          q[((i+1)%16)*16 + ((j+15)%16)]; // Top-left
      end
    end
  endgenerate
endmodule

module CellUpdater (
  input [255:0] q,
  input [255:0] neighbors,
  output reg [255:0] next_q
);
  genvar i, j;
  generate
    for (i = 0; i < 16; i = i + 1) begin : ROW_LOOP
      for (j = 0; j < 16; j = j + 1) begin : COL_LOOP
        always @(*) begin
          int alive_neighbors = neighbors[i*16 + j]; // Neighbors count
          
          if (q[i*16 + j] == 1) begin // Current cell alive
            case(alive_neighbors)
              0, 1, 4, 5, 6, 7, 8: next_q[i*16 + j] = 0; // Cell becomes dead
              2, 3: next_q[i*16 + j] = 1; // Cell remains alive
            endcase
          end
          else begin // Current cell dead
            case(alive_neighbors)
              3: next_q[i*16 + j] = 1; // Cell becomes alive
              0, 1, 2, 4, 5, 6, 7, 8: next_q[i*16 + j] = 0; // Cell remains dead
            endcase
          end
        end
      end
    end
  endgenerate
endmodule

module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

  reg [255:0] next_q;
  wire [255:0] neighbors;

  NeighborsCalculator neighbors_inst (
    .q(q),
    .neighbors(neighbors)
  );

  CellUpdater updater_inst (
    .q(q),
    .neighbors(neighbors),
    .next_q(next_q)
  );

  always @(posedge clk) begin
    if (load)
      q <= data;
    else
      q <= next_q;
  end

endmodule