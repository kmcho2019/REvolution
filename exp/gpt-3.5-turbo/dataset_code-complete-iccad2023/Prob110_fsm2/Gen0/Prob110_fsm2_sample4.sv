module TopModule (
  input clk,
  input j,
  input k,
  input areset,
  output reg out
);

// Define states
parameter OFF = 2'b00;
parameter ON = 2'b01;

reg [1:0] state, next_state;

// State transition and output logic
always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= OFF;
    out <= 0;
  end
  else begin
    state <= next_state;
    case (state)
      OFF: begin
        if (j)   next_state <= ON;
        else     next_state <= OFF;
        out <= 0;
      end
      ON: begin
        if (k)   next_state <= OFF;
        else     next_state <= ON;
        out <= 1;
      end
    endcase
  end
end

endmodule