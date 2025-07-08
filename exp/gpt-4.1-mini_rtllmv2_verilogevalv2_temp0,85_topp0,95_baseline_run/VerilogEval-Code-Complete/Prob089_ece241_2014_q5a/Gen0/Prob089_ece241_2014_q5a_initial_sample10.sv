module TopModule (
  input clk,
  input areset,
  input x,
  output reg z
);

  // State encoding
  localparam STATE_WAIT = 1'b0,
             STATE_FLIP = 1'b1;

  reg state;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= STATE_WAIT;
      z <= 1'b0;
    end else begin
      case (state)
        STATE_WAIT: begin
          z <= x;
          if (x == 1'b1)
            state <= STATE_FLIP;
        end

        STATE_FLIP: begin
          z <= ~x;
          state <= STATE_FLIP;
        end

        default: begin
          state <= STATE_WAIT;
          z <= 1'b0;
        end
      endcase
    end
  end

endmodule