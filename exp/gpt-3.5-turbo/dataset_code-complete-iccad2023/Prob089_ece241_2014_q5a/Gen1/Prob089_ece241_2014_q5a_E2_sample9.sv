module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

reg [1:0] state;
parameter IDLE = 2'b00;

always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= IDLE;
    z <= 1'b0;
  end
  else begin
    case(state)
      IDLE: begin
        if (x == 1'b0)
          z <= z;
        else
          z <= ~z;
      end
    endcase

    if (x == 1 && state == IDLE) begin
        state <= IDLE;
    end else if (state == IDLE) begin
        state <= IDLE;
    end else begin
        state <= IDLE;
    end
  end
end

endmodule