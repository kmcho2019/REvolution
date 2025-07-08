module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);
  integer i;
  reg [511:0] next_q;

  // Function to compute next state of a cell based on its neighbors using Rule 110
  function rule110;
    input left, center, right;
    begin
      // Compute the 3-bit pattern: {left, center, right}
      case ({left, center, right})
        3'b111: rule110 = 1'b0;
        3'b110: rule110 = 1'b1;
        3'b101: rule110 = 1'b1;
        3'b100: rule110 = 1'b0;
        3'b011: rule110 = 1'b1;
        3'b010: rule110 = 1'b1;
        3'b001: rule110 = 1'b1;
        3'b000: rule110 = 1'b0;
        default: rule110 = 1'b0; // default case for safety
      endcase
    end
  endfunction

  always @* begin
    for (i = 0; i < 512; i = i + 1) begin
      // Determine neighbors with boundary conditions
      // left neighbor is q[i+1] if i<511 else 0
      // right neighbor is q[i-1] if i>0 else 0
      // center is q[i]
      reg left, center, right;
      left = (i == 511) ? 1'b0 : q[i+1];
      center = q[i];
      right = (i == 0) ? 1'b0 : q[i-1];
      next_q[i] = rule110(left, center, right);
    end
  end

  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      q <= next_q;
    end
  end
endmodule