module TopModule (
  input clk,
  input enable,
  input S,
  input A,
  input B,
  input C,
  output reg Z
);
  reg [7:0] Q;

  // Shift register with synchronous active-high enable
  always @(posedge clk) begin
    if (enable) begin
      Q <= {Q[6:0], S};  // shift in S at Q[0], Q[0] is MSB shifted in first
    end
  end

  // Multiplexer to select Q[x] based on ABC
  wire [2:0] sel = {A, B, C};
  wire selected_bit;
  assign selected_bit = Q[sel];

  // Assign output Z synchronously at clk
  always @(posedge clk) begin
    Z <= selected_bit;
  end

endmodule