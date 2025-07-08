module TopModule (
  input clk,
  input enable,
  input S,
  input A,
  input B,
  input C,
  output reg Z
);

  reg [7:0] Q; // Q[0] is MSB shifted in first
  
  always @(posedge clk) begin
    if (enable) begin
      Q <= {Q[6:0], S}; // shift right, MSB is Q[0], new bit at Q[0]
    end
  end

  wire [2:0] addr = {A,B,C};
  wire selected_bit;

  // 8-to-1 mux to select Q[addr]
  assign selected_bit = Q[addr];
  
  always @(*) begin
    Z = selected_bit;
  end

endmodule