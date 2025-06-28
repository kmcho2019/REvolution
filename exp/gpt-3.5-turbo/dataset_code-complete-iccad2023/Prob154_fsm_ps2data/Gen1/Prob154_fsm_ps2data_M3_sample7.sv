module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

// Define states
reg [1:0] state;
parameter IDLE = 2'b00;
parameter CAPTURE_MESSAGE = 2'b01;

// Define signals
reg [7:0] message[2:0]; // Array to store the 3 bytes of the message
reg [2:0] count; // Counter to keep track of the number of bytes captured

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    out_bytes <= 24'hxx_xxxxxxxx; // Initialize output to "x"
    done <= 0;
    count <= 0;
  end
  else begin
    case(state)
      IDLE:
        if (in[3] == 1) begin
          state <= CAPTURE_MESSAGE;
          message[0] <= in;
          count <= 1;
        end
      CAPTURE_MESSAGE:
        begin
          message[count] <= in;
          count <= count + 1;
          if (count == 3) begin
            out_bytes <= {message[2], message[1], message[0]};
            done <= 1;
            state <= IDLE;
          end
        end
    endcase
  end
end

endmodule