module TopModule (
  input clk,
  input j,
  input k,
  input reset,
  output reg out
);

  // State encoding
  parameter OFF = 2'b00;
  parameter ON = 2'b01;

  // State register
  reg [1:0] state;

  // State and output logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= OFF;
      out <= 1'b0;
    end else begin
      if (state == OFF) begin
        if (j) begin
          state <= ON;
        end
        out <= 1'b0;
      end else begin
        if (k) begin
          state <= OFF;
        end
        out <= 1'b1;
      end
    end
  end

endmodule