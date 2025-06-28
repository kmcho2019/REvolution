module Rule110 (
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
  output reg [513:0] q
);

  reg [511:0] next_q;

  always @* begin
    q[0] = 1'b0; // Boundary condition for q[-1]
    q[511] = 1'b0; // Boundary condition for q[512]

    for (int i = 1; i < 512; i = i + 1) begin : rule110_inst
      Rule110 rule110_inst (
        .left(q[i-1]),
        .center(q[i]),
        .right(q[i+1]),
        .next_state(next_q[i])
      );
    end
  end

  always @(posedge clk) begin
    if (load)
      q <= {1'b0, data, 1'b0}; // Load data with zero boundaries
    else
      q <= next_q;
  end

endmodule