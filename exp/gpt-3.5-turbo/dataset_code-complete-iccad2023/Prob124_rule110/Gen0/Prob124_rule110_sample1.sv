module Rule110_Cell (
  input left,
  input center,
  input right,
  output reg next_state
);

always @(*)
begin
  case({left, center, right})
    3'b111: next_state = 1;
    3'b110: next_state = 0;
    3'b101: next_state = 0;
    3'b100: next_state = 1;
    3'b011: next_state = 1;
    3'b010: next_state = 1;
    3'b001: next_state = 1;
    3'b000: next_state = 0;
  endcase
end

endmodule

module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

reg [511:0] next_q;

// Create instances of Rule110_Cell module for each cell
genvar i;
generate
  for (i = 0; i < 512; i=i+1) begin : cell_instance
    Rule110_Cell cell(
      i > 0 ? q[i-1] : 0,
      q[i],
      i < 511 ? q[i+1] : 0,
      next_q[i]
    );
  end
endgenerate

always @(posedge clk)
begin
  if (load)
    q <= data;
  else
    q <= next_q;
end

endmodule