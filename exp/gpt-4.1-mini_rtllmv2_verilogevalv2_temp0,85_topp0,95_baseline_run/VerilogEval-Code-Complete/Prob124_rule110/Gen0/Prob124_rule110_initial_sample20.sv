module TopModule (
  input clk,
  input load,
  input [511:0] data,
  output reg [511:0] q
);
  wire [513:0] extended; // zero-extended with 0 at both ends
  reg [511:0] next_q;
  
  assign extended = {1'b0, q, 1'b0};

  integer i;
  always @(*) begin
    for (i = 0; i < 512; i = i + 1) begin
      // extract neighbors
      // Left = extended[i+2], Center = extended[i+1], Right = extended[i]
      // Apply Rule 110:
      // pattern (Left Center Right) => next state
      // 111=7->0, 110=6->1, 101=5->1, 100=4->0, 011=3->1, 010=2->1, 001=1->1, 000=0->0
      case ({extended[i+2], extended[i+1], extended[i]})
        3'b111: next_q[i] = 1'b0;
        3'b110: next_q[i] = 1'b1;
        3'b101: next_q[i] = 1'b1;
        3'b100: next_q[i] = 1'b0;
        3'b011: next_q[i] = 1'b1;
        3'b010: next_q[i] = 1'b1;
        3'b001: next_q[i] = 1'b1;
        3'b000: next_q[i] = 1'b0;
        default: next_q[i] = 1'b0;
      endcase
    end
  end

  always @(posedge clk) begin
    if (load)
      q <= data;
    else
      q <= next_q;
  end

endmodule