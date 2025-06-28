module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output [23:0] out_bytes,
  output reg done
);

  reg [7:0] msg_bytes [0:2];
  reg [1:0] counter;

  always @ (posedge clk) begin
    if (reset)
      counter <= 2'b00;
    else begin
      case (counter)
        2'b00: begin // IDLE
          if (in[3])
            counter <= 2'b01; // Move to receiving first byte
        end
        2'b01: begin // Receiving first byte
          msg_bytes[0] <= in;
          counter <= 2'b10; // Move to second byte
        end
        2'b10: begin // Receiving second byte
          msg_bytes[1] <= in;
          counter <= 2'b11; // Move to third byte
        end
        2'b11: begin // Receiving third byte
          msg_bytes[2] <= in;
          out_bytes <= {msg_bytes[0], msg_bytes[1], msg_bytes[2]}; // Output 3 byte message
          done <= 1; // Message reception complete
          counter <= 2'b00; // Reset counter for next message
        end
      endcase
    end
  end

endmodule