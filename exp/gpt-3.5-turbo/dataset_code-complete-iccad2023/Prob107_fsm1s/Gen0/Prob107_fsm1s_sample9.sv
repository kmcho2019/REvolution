module TopModule (
  input clk,
  input in,
  input reset,
  output reg out
);

  reg state, next_state;

  always @(posedge clk) begin
    if (reset) begin
      state <= 1'b1; // initial state B
    end
    else begin
      case (state)
        1'b1: begin // state B
          if (in == 1'b1) begin
            next_state = 1'b1;
            out = 1'b1;
          end
          else begin
            next_state = 1'b0;
            out = 1'b0;
          end
        end
        1'b0: begin // state A
          if (in == 1'b1) begin
            next_state = 1'b0;
            out = 1'b0;
          end
          else begin
            next_state = 1'b1;
            out = 1'b1;
          end
        end
      endcase
      state <= next_state;
    end
  end
endmodule