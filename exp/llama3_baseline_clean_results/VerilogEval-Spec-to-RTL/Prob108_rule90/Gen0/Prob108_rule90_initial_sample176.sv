module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

always @ (posedge clk) begin
  if (load) begin
    current_state <= data;
  end else begin
    current_state <= next_state;
  end
end

always @ (*) begin
  next_state = 0;
  for (int i = 0; i < 512; i++) begin
    if (i == 0) begin
      next_state[i] = current_state[i+1] ^ 1'b0;
    end else if (i == 511) begin
      next_state[i] = current_state[i-1] ^ 1'b0;
    end else begin
      next_state[i] = current_state[i-1] ^ current_state[i+1];
    end
  end
end

assign q = current_state;

endmodule