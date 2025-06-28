module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

reg [1:0] state;
parameter IDLE = 2'b00;
parameter CONVERT = 2'b01;

always @(posedge clk or posedge areset) begin
  if (areset) begin
    state <= IDLE;
    z <= 1'b0;
  end
  else begin
    case(state)
      IDLE: begin
        if (x == 1'b1)
          state <= CONVERT;
      end
      CONVERT: begin
        if (x == 1'b0)
          state <= IDLE;
      end
      default: state <= IDLE;
    endcase
  end
end

always @* begin
  case(state)
    IDLE: z = z;
    CONVERT: z = ~z;
    default: z = 1'b0;
  endcase
end

endmodule