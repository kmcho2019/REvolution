module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  integer i;
  reg left, center, right;
  reg next_state;

  // Function to compute the next state based on Rule 110 table
  // Inputs: left, center, right bits
  function rule110;
    input l, c, r;
    begin
      // Combine bits to a 3-bit number: {l,c,r}
      case ({l, c, r})
        3'b111: rule110 = 1'b0;
        3'b110: rule110 = 1'b1;
        3'b101: rule110 = 1'b1;
        3'b100: rule110 = 1'b0;
        3'b011: rule110 = 1'b1;
        3'b010: rule110 = 1'b1;
        3'b001: rule110 = 1'b1;
        3'b000: rule110 = 1'b0;
        default: rule110 = 1'b0; // Default case (should not happen)
      endcase
    end
  endfunction

  reg [511:0] q_next;

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      for (i = 0; i < 512; i = i + 1) begin
        left   = (i == 511) ? 1'b0 : q[i+1];
        center = q[i];
        right  = (i == 0) ? 1'b0 : q[i-1];
        q_next[i] = rule110(left, center, right);
      end
      q <= q_next;
    end
  end

endmodule