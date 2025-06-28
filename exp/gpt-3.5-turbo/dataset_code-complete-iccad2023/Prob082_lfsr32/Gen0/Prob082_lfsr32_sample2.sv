module TopModule (
  input clk,
  input reset,
  output reg [31:0] q
);

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      q <= 32'h1; // Initialize q to 32'h1 on reset
    end 
    else begin
      q <= {q[30] ^ q[21] ^ q[1] ^ q[0], q[31:1]}; // Calculate next state based on taps
    end
  end

endmodule