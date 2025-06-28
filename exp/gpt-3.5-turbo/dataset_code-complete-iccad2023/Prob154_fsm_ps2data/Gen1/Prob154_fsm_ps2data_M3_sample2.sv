module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

// Define FSM states
parameter IDLE = 2'b00;
parameter CAPTURE = 2'b01;

// Define signals
reg [1:0] state;
reg [7:0] bytes [0:2];

// FSM
always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= IDLE;
    done <= 0;
    out_bytes <= 24'b0;
  end
  else begin
    case (state)
      IDLE:
        if (in[3] == 1) begin
          bytes[0] <= in;
          state <= CAPTURE;
        end
      CAPTURE:
        begin
          bytes[state - 1] <= in;
          if (state == 2) begin
            out_bytes <= {bytes[0], bytes[1], in};
            done <= 1;
            state <= IDLE;
          end
          else
            state <= state + 1;
        end
    endcase
  end
end

endmodule