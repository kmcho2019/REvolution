module TopModule (
  input clk,
  input [7:0] in,
  input reset,
  output reg [23:0] out_bytes,
  output reg done
);

// Define states
parameter WAIT = 2'b00;
parameter RECEIVE_BYTE1 = 2'b01;
parameter RECEIVE_BYTE2 = 2'b10;
parameter RECEIVE_BYTE3 = 2'b11;

// Define signals
reg [1:0] state;

// FSM
always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= WAIT;
    out_bytes <= 24'hxxxxxx;
    done <= 0;
  end else begin
    case (state)
      WAIT:
        begin
          if (in[3] == 1)
            state <= RECEIVE_BYTE1;
        end
      RECEIVE_BYTE1:
        begin
          out_bytes[23:16] <= in;
          state <= RECEIVE_BYTE2;
        end
      RECEIVE_BYTE2:
        begin
          out_bytes[15:8] <= in;
          state <= RECEIVE_BYTE3;
        end
      RECEIVE_BYTE3:
        begin
          out_bytes[7:0] <= in;
          state <= WAIT;
          done <= 1;
        end
    endcase
  end
end

endmodule