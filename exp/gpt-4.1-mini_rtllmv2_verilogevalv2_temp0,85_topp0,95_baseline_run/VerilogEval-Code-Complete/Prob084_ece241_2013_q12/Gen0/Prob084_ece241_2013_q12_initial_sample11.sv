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

  // Shift register: shift in S on enable
  always @(posedge clk) begin
    if (enable) begin
      Q <= {Q[6:0], S};
    end
  end

  // Multiplexer to select output based on ABC
  wire [2:0] addr = {A,B,C};
  wire selected_bit;

  assign selected_bit = Q[addr];

  // Output register Z updated combinationally from selected bit
  always @(*) begin
    Z = selected_bit;
  end

endmodule