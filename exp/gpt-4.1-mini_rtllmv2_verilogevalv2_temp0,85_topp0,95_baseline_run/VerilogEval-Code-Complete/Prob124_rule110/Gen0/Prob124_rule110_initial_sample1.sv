module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);

  reg [511:0] next_q;

  // Compute next state combinationally
  always @(*) begin
    integer i;
    for (i = 0; i < 512; i = i + 1) begin
      // Define neighbors with boundary conditions
      // left neighbor = q[i+1], or 0 if i == 511
      // right neighbor = q[i-1], or 0 if i == 0
      // center = q[i]
      // Note: The problem statement indicates neighbors as Left[i+1], Center[i], Right[i-1]
      // So left = q[i+1] if i < 511 else 0
      // right = q[i-1] if i > 0 else 0
      // center = q[i]

      reg left, center, right;
      left = (i == 511) ? 1'b0 : q[i+1];
      center = q[i];
      right = (i == 0) ? 1'b0 : q[i-1];

      // Apply Rule 110 logic:
      // (left, center, right) -> next center
      // 111 -> 0
      // 110 -> 1
      // 101 -> 1
      // 100 -> 0
      // 011 -> 1
      // 010 -> 1
      // 001 -> 1
      // 000 -> 0

      case ({left, center, right})
        3'b111: next_q[i] = 1'b0;
        3'b110: next_q[i] = 1'b1;
        3'b101: next_q[i] = 1'b1;
        3'b100: next_q[i] = 1'b0;
        3'b011: next_q[i] = 1'b1;
        3'b010: next_q[i] = 1'b1;
        3'b001: next_q[i] = 1'b1;
        3'b000: next_q[i] = 1'b0;
        default: next_q[i] = 1'b0; // default should not occur
      endcase
    end
  end

  // Sequential update
  always @(posedge clk) begin
    if (load) begin
      q <= data;
    end else begin
      q <= next_q;
    end
  end

endmodule