module TopModule (
  input clk,
  input shift_ena,
  input count_ena,
  input data,
  output reg [3:0] q
);

  reg [3:0] temp;

  always @(posedge clk) begin
    temp <= q; // Store current value of q in temporary register

    if (shift_ena & ~count_ena) begin
      q <= {q[2:0], data}; // Shift data in if shift_ena is 1
    end

    if (count_ena & ~shift_ena) begin
      q <= q - 1; // Decrement q if count_ena is 1
    end

    // If both shift_ena and count_ena are high, behavior is arbitrary
  end

endmodule