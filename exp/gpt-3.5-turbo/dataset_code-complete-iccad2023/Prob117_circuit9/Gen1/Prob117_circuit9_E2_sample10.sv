module TopModule (
  input clk,
  input a,
  output reg [2:0] q
);

  reg [2:0] counter_q;
  reg d;
  wire [2:0] dff_out;

  assign dff_out = {counter_q[1:0], a};

  always @ (posedge clk) begin
    if (a == 1'b1) begin
      if (counter_q < 3'd6) // Increment counter from 0 to 6
        counter_q <= counter_q + 3'b1;
      if (a == 1'b0) // Capture current counter value on D flip-flop input
        d = counter_q[2];
    end
  end

  always @* begin
    if (a == 0)
      q <= d; // Output the captured value on the D flip-flop
    else
      q <= counter_q; // Output the current value of the counter
  end

endmodule