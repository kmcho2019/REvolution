module Cell (
  input clk,
  input [255:0] q,
  output reg [255:0] next_q
);

  always @(posedge clk) begin
    genvar i, j;
    for (i = 0; i < 16; i = i + 1) begin
      for (j = 0; j < 16; j = j + 1) begin
        int neighbors = 0;
        if (q[i*16 + ((j+1) & 15)]) neighbors = neighbors + 1;          
        if (q[i*16 + ((j-1) & 15)]) neighbors = neighbors + 1;          
        if (q[((i+1) & 15) * 16 + j]) neighbors = neighbors + 1;        
        if (q[((i-1) & 15) * 16 + j]) neighbors = neighbors + 1;        
        if (q[((i+1) & 15) * 16 + ((j+1) & 15)]) neighbors = neighbors + 1;  
        if (q[((i+1) & 15) * 16 + ((j-1) & 15)]) neighbors = neighbors + 1;  
        if (q[((i-1) & 15) * 16 + ((j+1) & 15)]) neighbors = neighbors + 1;  
        if (q[((i-1) & 15) * 16 + ((j-1) & 15)]) neighbors = neighbors + 1;  

        if (neighbors == 3) begin
          next_q[i*16 + j] <= 1;  // Cell becomes alive
        end
        else if (neighbors == 2) begin
          next_q[i*16 + j] <= q[i*16 + j];  // Cell state does not change
        end
        else begin
          next_q[i*16 + j] <= 0;  // Cell becomes dead
        end
      end
    end
  end
endmodule

module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

  // Implementing the cell module for updating the grid
  Cell cell_inst (
    .clk(clk),
    .q(q),
    .next_q(q)
  );

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end
  end

endmodule