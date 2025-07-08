module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  // Function implementing Rule 110 for a given 3-bit neighborhood
  function rule110;
    input [2:0] neighborhood; // {left, center, right}
    begin
      case (neighborhood)
        3'b111: rule110 = 1'b0;
        3'b110: rule110 = 1'b1;
        3'b101: rule110 = 1'b1;
        3'b100: rule110 = 1'b0;
        3'b011: rule110 = 1'b1;
        3'b010: rule110 = 1'b1;
        3'b001: rule110 = 1'b1;
        3'b000: rule110 = 1'b0;
        default: rule110 = 1'b0;
      endcase
    end
  endfunction

  reg [511:0] next_q;

  integer i;
  always @(*) begin
    for (i = 0; i < 512; i = i + 1) begin
      // Determine neighbors with boundary zeros
      // left = q[i+1] if i+1<512 else 0
      // right = q[i-1] if i-1>=0 else 0
      // center = q[i]
      // Note: The problem's table lists Left[i+1], Center[i], Right[i-1]
      // so neighbors indexing: left = q[i+1], center = q[i], right = q[i-1]
      // For boundary cells, missing neighbors = 0
      reg left, center, right;
      left   = (i < 511) ? q[i+1] : 1'b0;
      center = q[i];
      right  = (i > 0)   ? q[i-1] : 1'b0;
      next_q[i] = rule110({left, center, right});
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