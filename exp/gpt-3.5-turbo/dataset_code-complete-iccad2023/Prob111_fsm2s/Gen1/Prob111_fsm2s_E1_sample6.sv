module TopModule (
  input clk,
  input j,
  input k,
  input reset,
  output reg out
);

// State encoding
parameter OFF = 1'b0;
parameter ON = 1'b1;

// State and output logic
reg state = OFF;

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    state <= OFF;
    out <= 1'b0;
  end else begin
    case (state)
      OFF: begin
        state <= j ? ON : OFF;
        out <= 1'b0;
      end
      ON: begin
        state <= k ? OFF : ON;
        out <= 1'b1;
      end
    endcase
  end
end

endmodule