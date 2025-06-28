module cell (
  input clk,
  input [255:0] current_state,
  output reg [255:0] next_state
);

always @(posedge clk) begin
  integer i;
  for (i = 0; i < 256; i = i + 1) begin
    integer neighbors = current_state[((i+15)%16) + ((i+240)%256) + ((i+1)%16) + ((i+16)%256) + ((i+17)%16) + ((i+255)%256) + ((i+241)%256) + ((i+257)%256)];
    
    if (neighbors <= 1)
      next_state[i] = 0;
    else if (neighbors == 2)
      next_state[i] = current_state[i];
    else if (neighbors == 3)
      next_state[i] = 1;
    else
      next_state[i] = 0;
  end
end

endmodule

module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

always @(posedge clk) begin
  if (load) begin
    current_state <= data;
    q <= data;
  end else begin
    current_state <= next_state;
    q <= next_state;
  end
end

genvar i;
generate
  for (i = 0; i < 256; i = i + 1) begin : CELL_INST
    cell cell_inst (
      .clk(clk),
      .current_state(current_state),
      .next_state(next_state)
    );
  end
endgenerate

endmodule