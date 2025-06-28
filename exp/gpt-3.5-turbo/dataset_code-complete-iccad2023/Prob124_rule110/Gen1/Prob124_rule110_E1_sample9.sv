module Rule110Cell (
  input left,
  input center,
  input right,
  output reg next_state
);

  always @* begin
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

  wire [511:0] next_states;

  // Instantiate Rule110Cell for every cell
  Rule110Cell cells[511:0](
    .left(q[510:0]),
    .center(q),
    .right(q[0:510]),
    .next_state(next_states)
  );

  always @(posedge clk) begin
    if (load) begin
      q <= data; // Load data when load is active
    end else begin
      q <= next_states; // Update cell states with calculated next states
    end
  end

endmodule