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

reg [1:0] state, next_state;

always @ (posedge clk or posedge reset) begin
  if (reset) begin
    state <= OFF;
  end else begin
    case (state)
      OFF: begin
        if (j)
          next_state = ON;
        else
          next_state = OFF;
      end
      ON: begin
        if (k)
          next_state = OFF;
        else
          next_state = ON;
      end
    endcase
    state <= next_state;
  end
end

always @* begin
  case (state)
    OFF: out = 1'b0;
    ON: out = 1'b1;
  endcase
end

endmodule