module TopModule (
  input clk,
  input L,
  input q_in,
  input r_in,
  output reg Q
);

  reg [1:0] state; // 0: idle, 1: load, 2: update

  always @(posedge clk) begin
    case (state)
      2'b00: begin // idle
        if (L) begin
          state <= 2'b01; // transition to load state
          Q <= r_in;
        end else begin
          state <= 2'b10; // transition to update state
          Q <= q_in;
        end
      end
      2'b01: begin // load
        state <= 2'b00; // transition back to idle
      end
      2'b10: begin // update
        state <= 2'b00; // transition back to idle
      end
      default: begin
        state <= 2'b00; // default to idle state
      end
    endcase
  end

endmodule