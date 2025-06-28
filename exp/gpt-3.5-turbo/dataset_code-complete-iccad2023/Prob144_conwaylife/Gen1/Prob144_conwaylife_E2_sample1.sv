module NextState (
  input [255:0] q,
  output reg [255:0] next_q
);
  
  integer i, j;
  
  always @* begin
    for (i = 0; i < 16; i = i + 1) begin
      for (j = 0; j < 16; j = j + 1) begin
        int neighbors = q[((i-1) & 15) * 16 + ((j-1) & 15)] +
                        q[((i-1) & 15) * 16 + j] +
                        q[((i-1) & 15) * 16 + ((j+1) & 15)] +
                        q[i * 16 + ((j-1) & 15)] +
                        q[i * 16 + ((j+1) & 15)] +
                        q[((i+1) & 15) * 16 + ((j-1) & 15)] +
                        q[((i+1) & 15) * 16 + j] +
                        q[((i+1) & 15) * 16 + ((j+1) & 15)];
        
        if (neighbors == 3)
          next_q[i*16 + j] = 1;  // Cell becomes alive
        else if (neighbors == 2)
          next_q[i*16 + j] = q[i*16 + j];  // Cell state does not change
        else
          next_q[i*16 + j] = 0;  // Cell becomes dead
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

  // Instantiate NextState module
  NextState next_state_inst (
    .q(q),
    .next_q(q)
  );

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end
  end

endmodule