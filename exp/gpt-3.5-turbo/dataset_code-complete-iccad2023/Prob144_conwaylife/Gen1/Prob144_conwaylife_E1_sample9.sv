module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

reg [255:0] shifted_q;
reg [255:0] next_q;

always @(posedge clk) begin
  if (load) begin
    q <= data;
  end else begin
    // Shift grid horizontally
    for (int i = 0; i < 16; i = i + 1) begin
      shifted_q[i*16 +: 16] = {q[i*16+1 -: 1], q[i*16]};
    end

    for (int i = 0; i < 16; i = i + 1) begin
      for (int j = 0; j < 16; j = j + 1) begin
        integer neighbors = 
            shifted_q[i*16 + j-1] + shifted_q[i*16 + j+1] +
            shifted_q[(i-1)*16 + j] + shifted_q[(i+1)*16 + j] +
            shifted_q[(i-1)*16 + j-1] + shifted_q[(i-1)*16 + j+1] +
            shifted_q[(i+1)*16 + j-1] + shifted_q[(i+1)*16 + j+1];
        
        if (neighbors <= 1 || neighbors >= 4) begin
          next_q[i*16 + j] = 0; // Cell becomes 0
        end else if (neighbors == 3) begin
          next_q[i*16 + j] = 1; // Cell becomes 1
        end else begin
          next_q[i*16 + j] = q[i*16 + j]; // Cell state does not change
        end
      end
    end

    q <= next_q;
  end
end

endmodule