module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output [23:0] out_bytes,
  output reg done
);

  reg [2:0] state;
  reg [23:0] msg_buffer;

  always @ (posedge clk or posedge reset) begin
    if (reset) begin
      state <= 3'b000; // START state
      done <= 0;
      msg_buffer <= 24'b0;
    end else begin
      case (state)
        3'b000: begin // START state
          if (in[3] == 1) begin
            state <= 3'b001; // RECEIVE state
            msg_buffer[23:16] <= in;
          end
        end
        3'b001: begin // RECEIVE state (1st byte)
          msg_buffer[15:8] <= in;
          state <= 3'b010;
        end
        3'b010: begin // RECEIVE state (2nd byte)
          msg_buffer[7:0] <= in;
          state <= 3'b011;
        end
        3'b011: begin // RECEIVE state (3rd byte)
          done <= 1;
          state <= 3'b000; // Restart state for next message
        end
      endcase
    end
  end

  assign out_bytes = done ? msg_buffer : 24'bxxxxxxxxxxxxxxxxxxxxxxxx;

endmodule