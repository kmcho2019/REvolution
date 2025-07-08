module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  reg [1:0] state; // 0: waiting for start byte, 1 or 2: collecting bytes, 3: done cycle

  always @(posedge clk) begin
    if (reset) begin
      state <= 0;
      out_bytes <= 24'd0;
      done <= 1'b0;
    end else begin
      done <= 1'b0; // default done to 0 each cycle

      case (state)
        0: begin
          // Waiting for start byte with in[3]==1
          if (in[3] == 1'b1) begin
            out_bytes <= {in, 16'd0}; // store first byte in MSB position
            state <= 1;
          end
        end
        1: begin
          // Received first byte, now store second byte
          out_bytes <= {out_bytes[15:0], in};
          state <= 2;
        end
        2: begin
          // Received second byte, now store third byte
          out_bytes <= {out_bytes[15:0], in};
          state <= 3;
        end
        3: begin
          // After 3rd byte, signal done one cycle and then go back to state 0
          done <= 1'b1;
          state <= 0;
        end
        default: state <= 0;
      endcase
    end
  end

endmodule