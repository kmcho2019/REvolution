module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

  // State encoding not strictly needed, use counter only
  // counter = 0 means waiting for first byte with in[3]=1
  // counter = 1 or 2 means collecting message bytes
  // counter = 3 means message complete, done asserted
  reg [1:0] counter;
  reg [23:0] message_shift;

  always @(posedge clk) begin
    if (reset) begin
      counter <= 2'd0;
      done <= 1'b0;
      out_bytes <= 24'd0;
      message_shift <= 24'd0;
    end else begin
      done <= 1'b0; // default no done

      case (counter)
        2'd0: begin
          // Waiting for first byte with in[3] = 1
          if (in[3]) begin
            // Start message collection
            message_shift <= {in, 16'd0}; // Store byte 1 in top 8 bits
            counter <= 2'd1;
          end
          // else remain in state 0
        end

        2'd1: begin
          // Receiving second byte
          message_shift <= {message_shift[15:0], in};
          counter <= 2'd2;
        end

        2'd2: begin
          // Receiving third byte
          message_shift <= {message_shift[15:0], in};
          counter <= 2'd3;
        end

        2'd3: begin
          // Message complete, assert done and output message_shift
          done <= 1'b1;
          out_bytes <= message_shift;
          // After done cycle, reset counter to 0 for next message
          counter <= 2'd0;
        end

        default: begin
          counter <= 2'd0;
          done <= 1'b0;
        end
      endcase
    end
  end

endmodule