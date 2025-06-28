module TopModule (
  input clk,
  input j,
  input k,
  input reset,
  output reg out
);

// Define states
parameter OFF = 2'b00;
parameter ON = 2'b01;

reg [1:0] state;

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    state <= OFF;
    out <= 1'b0;
  end else begin
    case (state)
      OFF: begin
        if (j) begin
          state <= ON;
        end
        else begin
          state <= OFF;
        end
        out <= 1'b0;
      end
      ON: begin
        if (k) begin
          state <= OFF;
        end
        else begin
          state <= ON;
        end
        out <= 1'b1;
      end
    endcase
  end
end

endmodule