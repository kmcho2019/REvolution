module Cell (
  input left,
  input center,
  input right,
  output reg next_state
);

always @(*)
begin
  case({left, center, right})
    3'b111: next_state = 1'b0;
    3'b110: next_state = 1'b1;
    3'b101: next_state = 1'b1;
    3'b100: next_state = 1'b0;
    3'b011: next_state = 1'b1;
    3'b010: next_state = 1'b1;
    3'b001: next_state = 1'b1;
    3'b000: next_state = 1'b0;
  endcase
end

endmodule

module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);
  
  reg [511:0] next_state_pipeline [0:511];
  integer i;
  
  // Pipeline stages for state transitions of each cell
  always @*
  begin
    for (i = 0; i < 512; i = i + 1)
    begin
      Cell cell_inst (
        .left(i == 0 ? 1'b0 : q[i-1]),
        .center(q[i]),
        .right(i == 511 ? 1'b0 : q[i+1]),
        .next_state(next_state_pipeline[i])
      );
    end
  end

  // Update cell states on positive edge of clock
  always @(posedge clk)
  begin
    if (load)
      q <= data;
    else
    begin
      for (i = 0; i < 512; i = i + 1)
      begin
        q[i] <= next_state_pipeline[i];
      end
    end
  end

endmodule