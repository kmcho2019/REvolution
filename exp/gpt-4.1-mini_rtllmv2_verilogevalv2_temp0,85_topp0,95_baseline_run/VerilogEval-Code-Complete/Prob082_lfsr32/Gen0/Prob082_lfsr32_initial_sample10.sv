module TopModule (
  input clk,
  input reset,
  output reg [31:0] q
);

  // Tap positions are bits 31, 21, 1, 0 (0-based indexing)
  wire feedback;
  wire [31:0] next_q;

  // feedback is q[0]
  assign feedback = q[0];

  // For each bit i from 31 downto 1:
  // if tap at i: next_q[i] = q[i] ^ feedback
  // else next_q[i] = q[i]
  // next_q[0] = feedback

  assign next_q[0] = feedback;
  assign next_q[1] = q[1]  ^ feedback; // tap at bit 1
  assign next_q[21] = q[21] ^ feedback; // tap at bit 21
  assign next_q[31] = q[31] ^ feedback; // tap at bit 31

  // For bits that are not tapped and not bit 0, next_q[i] = q[i]
  genvar i;
  generate
    for (i=2; i<21; i=i+1) begin : no_tap1
      assign next_q[i] = q[i];
    end
    for (i=22; i<31; i=i+1) begin : no_tap2
      assign next_q[i] = q[i];
    end
  endgenerate

  always @(posedge clk) begin
    if (reset) begin
      q <= 32'h00000001;
    end else begin
      q <= next_q;
    end
  end

endmodule