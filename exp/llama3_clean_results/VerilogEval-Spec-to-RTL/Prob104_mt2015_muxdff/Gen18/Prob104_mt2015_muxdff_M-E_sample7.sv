module TopModule (
  input clk,
  input L,
  input q_in_1,
  input q_in_2,
  input r_in,
  output reg Q
);

  // Implement the XOR operation
  wire xor_result;
  assign xor_result = q_in_1 ^ q_in_2;

  // Use a multiplexer to select between the load input and the shifted output
  always @(posedge clk) begin
    if (L) begin
      Q <= r_in; // Load from r_in when L is high
    end else begin
      Q <= xor_result; // Shift and XOR when L is low
    end
  end

endmodule