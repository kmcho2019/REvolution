module TopModule (
  input clk,
  input reset,
  input data,
  output reg start_shifting
);

reg [3:0] state;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= 4'b0;
    start_shifting <= 0;
  end
  else begin
    case (state)
      4'b0000: if (data) state <= 4'b0001;
      4'b0001: if (data) state <= 4'b0010; else state <= 4'b0000; // check for 110
      4'b0010: if (data) state <= 4'b0011; else state <= 4'b0000; // check for 1101
      4'b0011: begin
        state <= 4'b0000;
        start_shifting <= 1; // Set shifting flag when 1101 found
      end
    endcase
  end
end

endmodule